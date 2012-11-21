# encoding: utf-8

namespace :crawl do
  task :courts, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources 'court', args[:offset], args[:limit]
  end
  
  task :judges, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources 'judges', args[:offset], args[:limit] 
  end

  namespace :hearings do
    task :civil, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources 'civil_hearing', args[:offset], args[:limit]
    end

    task :criminal, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources 'criminal_hearing', args[:offset], args[:limit]
    end

    task :special, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources 'special_hearing', args[:offset], args[:limit]
    end
  end

  task :decrees, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources 'decree', args[:offset], args[:limit]
  end
end
