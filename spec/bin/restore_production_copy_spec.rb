# frozen_string_literal: true

require 'rails_helper'
require 'open3'

# The fixture is pg_dumpall's output for a small cluster: the opencourts role with a password, an opencourts_api
# database and opencourts_production. The script restores it into a database of its own on the test server.
RSpec.describe 'bin/restore-production-copy' do # rubocop:disable RSpec/DescribeClass -- a script, not a class
  def database
    'opencourts_restore_spec'
  end

  def login
    config = ActiveRecord::Base.connection_db_config.configuration_hash

    { host: config[:host], user: config[:username], password: config[:password] }.compact
  end

  def query(sql, dbname: database)
    connection = PG.connect(**login, dbname:, gssencmode: 'disable', options: '-c client_min_messages=warning')
    connection.exec(sql).values
  ensure
    connection&.close
  end

  def drop(name)
    query("DROP DATABASE IF EXISTS #{name} WITH (FORCE)", dbname: 'postgres')
  end

  def restore
    Tempfile.create(%w[production_backup .gz]) do |backup|
      Zlib::GzipWriter.open(backup.path) { |gzip| gzip.write(file_fixture('production_backup.sql').read) }

      environment = login.transform_keys { |key| "PG#{key.upcase}" }
      command = ['bin/restore-production-copy', '--database', database, '--keep', 'kept@example.com', backup.path]
      output, status = Open3.capture2e(environment, *command, stdin_data: "y\n", chdir: Rails.root.to_s)

      raise "bin/restore-production-copy failed:\n#{output}" unless status.success?
    end
  end

  # rubocop:disable RSpec/BeforeAfterAll -- a restore takes seconds; every example reads the one database it restores
  before(:context) do
    [database, "#{database}_restore"].each { |name| drop(name) }
    restore
  end

  after(:context) { drop(database) }
  # rubocop:enable RSpec/BeforeAfterAll

  it 'restores the tables, their indexes and sequences from the opencourts_production section' do
    expect(query('SELECT name FROM courts ORDER BY id').flatten).to eq(
      ['Okresný súd Žilina', "Krajský súd\tBratislava", 'Najvyšší súd']
    )
    expect(query("SELECT indexname FROM pg_indexes WHERE tablename = 'courts' ORDER BY 1").flatten).to eq(
      %w[courts_pkey index_courts_on_name]
    )
    expect(query("SELECT nextval('courts_id_seq')").flatten).to eq(['4'])
  end

  it 'restores data lines that read like the headers of the backup' do
    expect(query('SELECT version FROM schema_migrations ORDER BY 1').flatten).to eq(
      [
        '-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: opencourts',
        '-- Database "opencourts_api" dump',
        '-- PostgreSQL database cluster dump complete'
      ]
    )
  end

  it 'leaves out the other databases of the cluster' do
    expect(query("SELECT to_regclass('public.api_keys')").flatten).to eq([nil])
    expect(query("SELECT 1 FROM pg_database WHERE datname = 'opencourts_api'", dbname: 'postgres')).to be_empty
  end

  # The fixture's CREATE DATABASE names C; a database in the server's own default would sort differently on another
  # machine.
  it 'creates the database with the locale and encoding the backup names' do
    sql = "SELECT datcollate, datctype, pg_encoding_to_char(encoding) FROM pg_database WHERE datname = '#{database}'"

    expect(query(sql, dbname: 'postgres')).to eq([%w[C C UTF8]])
  end

  it 'masks the e-mail, password and tokens of every user but the kept one' do
    users = query('SELECT id, email, encrypted_password, confirmation_token FROM users ORDER BY id')

    expect(users.map { |user| user.values_at(0, 1, 3) }).to eq(
      [['1', 'user1@example.invalid', nil], ['2', 'user2@example.invalid', nil], ['3', 'kept@example.com', nil]]
    )
    expect(users.pluck(2)).to eq([users[0][2], users[0][2], '$2a$10$keptkeptkeptkeptkeptkeptkeptkeptkeptkeptkeptkeptk'])
    expect(User.new(encrypted_password: users[0][2])).to be_valid_password('password')
  end

  it 'takes away the admin rights of the masked users' do
    expect(query('SELECT id, admin FROM users ORDER BY id')).to eq([%w[1 f], %w[2 f], %w[3 t]])
  end

  it 'replaces the unsubscribe tokens of the masked users with random ones, like the app makes' do
    subscriptions = query('SELECT id, token FROM subscriptions ORDER BY id')
    masked = subscriptions.first(2)
    derived = masked.map { |id, _| Digest::SHA256.hexdigest("masked-subscription-#{id}") }

    expect(masked.map(&:last)).not_to include('token-of-admin', 'token-of-reader', *derived)
    expect(masked.map(&:last)).to all(match(/\A[A-Za-z0-9_-]{32}\z/))
    expect(subscriptions.last.last).to eq('token-of-kept')
  end
end
