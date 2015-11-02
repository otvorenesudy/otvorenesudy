namespace :backup do
  desc 'Creates database dump'
  task database: :environment do
    config = ActiveRecord::Base.connection_config
    path   = Rails.root.join('shared/backups')
    name   = "#{config[:database].gsub(/_/, '-')}-#{Time.now.strftime('%Y-%m-%d')}.sql"
    file   = "#{path}/#{name}"

    FileUtils.mkdir_p(path) unless File.exists?(path)

    `pg_dump -U #{config[:username]} #{config[:database]} > #{file}`
    `cd #{path} && tar czf #{name}.tar.gz #{name} && rm #{name}`
  end
end
