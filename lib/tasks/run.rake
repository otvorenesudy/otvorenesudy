namespace :run do
  # TODO refactor hide impl in justice_gov_sk
  
  # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
  task :crawlers, [:type, :decree_form] => :environment do |_, args|
    type = args[:type].to_s.camelcase.constantize
    
    options = { generic: true, safe: true, decree_form: args[:decree_form] }
    
    request, lister = JusticeGovSk.build_request_and_lister type, options
    
    puts "#{request}"
    puts "#{lister}"
    
    JusticeGovSk.run_lister lister, request, options do
      lister.crawl request
    end
    
    options = { safe: true, limit: 1 }
    
    options.merge! decree_form: args[:decree_form] if type == Decree

    1.upto lister.pages do |page|
      Resque.enqueue(JusticeGovSk::Job::ListCrawler, type.name, options.merge(offset: page))
    end
  end
end
