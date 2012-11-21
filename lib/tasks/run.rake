require 'resque/tasks'

namespace :run do
  # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
  task :crawlers, [:type, :decree_form] => :environment do |_, args|
    type = args[:type].to_s.camelcase.constantize
    
    lister, request = JusticeGovSk::Helpers::CrawlerHelper.build_lister_and_request type, args
    
    JusticeGovSk::Helpers::CrawlerHelper.run_lister lister, request, safe: true do
      lister.crawl request
    end
    
    options = { safe: true, limit: 1 }
    
    options.merge! decree_form: args[:decree_form] if type == Decree

    1.upto lister.pages do |page|
      Resque.enqueue(JusticeGovSk::Jobs::ListCrawlerJob, type.name, options.merge(offset: page))
    end
  end
end
