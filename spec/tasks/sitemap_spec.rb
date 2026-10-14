# frozen_string_literal: true

require 'rails_helper'
require 'rake'
require 'zlib'

# The sitemap search engines read (config/schedule.rb runs sitemap:refresh:no_ping daily).
RSpec.describe 'sitemap:refresh:no_ping', type: :task do
  let(:directory) { Rails.root.join('tmp/spec-sitemap') }

  before do
    Rails.application.load_tasks unless Rake::Task.task_defined?('sitemap:refresh:no_ping')
    FileUtils.rm_rf(directory)
    SitemapGenerator::Sitemap.reset!
    SitemapGenerator::Sitemap.public_path = directory.to_s
    SitemapGenerator::Sitemap.verbose = false
  end

  after { SitemapGenerator::Sitemap.reset! }

  # The addresses in every file generated (the index and its sitemaps).
  def urls
    %w[sitemap:create sitemap:refresh:no_ping].each { |task| Rake::Task[task].reenable }
    Rake::Task['sitemap:refresh:no_ping'].invoke

    directory.glob('**/*.xml.gz').flat_map do |path|
      Zlib::GzipReader.open(path) { |file| Nokogiri::XML(file.read).remove_namespaces!.xpath('//loc').map(&:text) }
    end
  end

  it 'lists the pages, courts, judges, hearings, decrees and proceedings in both languages' do
    court = create(:court)
    judge = create(:judge)
    hearing = create(:hearing, court:)
    decree = create(:decree, court:)
    proceeding = create(:proceeding)

    expect(urls).to include(
      'https://otvorenesudy.sk/about?l=sk', 'https://otvorenesudy.sk/decrees/uoo?l=en',
      "https://otvorenesudy.sk/courts/#{court.id}?l=sk", "https://otvorenesudy.sk/judges/#{judge.id}?l=en",
      "https://otvorenesudy.sk/hearings/#{hearing.id}?l=sk", "https://otvorenesudy.sk/decrees/#{decree.id}?l=sk",
      "https://otvorenesudy.sk/proceedings/#{proceeding.id}?l=en"
    )
  end

  it 'leaves out the hidden selection procedures' do
    SelectionProcedure.create!(uri: 'https://www.justice.gov.sk/vk/1', source: Source.of('JusticeGovSk'),
                               organization_name: 'Okresný súd Košice I',
                               organization_name_unprocessed: 'Okresný súd Košice I', position: 'sudca',
                               closed_at: 1.month.ago)

    expect(urls).to include('https://otvorenesudy.sk/about?l=sk')
    expect(urls).not_to include(a_string_matching(/selections/))
  end
end
