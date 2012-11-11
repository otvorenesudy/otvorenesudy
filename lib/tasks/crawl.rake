# encoding: utf-8

namespace :crawl do
  task :courts, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources({ type: 'court' }.merge args)
  end
  
  task :judges, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources({ type: 'judge' }.merge args) 
  end

  namespace :hearings do
    task :civil, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources({ type: 'civil_hearing' }.merge args)
    end

    task :criminal, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources({ type: 'criminal_hearing' }.merge args)
    end

    task :special, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources({ type: 'special_hearing' }.merge args)
    end
  end

  task :decrees, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources({ type: 'decree' }.merge args)
  end
end
