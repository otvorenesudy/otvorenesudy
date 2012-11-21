# encoding: utf-8

namespace :crawl do
  task :courts, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources Court, args[:offset], args[:limit]
  end
  
  task :judges, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources Judge, args[:offset], args[:limit] 
  end

  namespace :hearings do
    task :civil, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources CivilHearing, args[:offset], args[:limit]
    end

    task :criminal, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources CriminalHearing, args[:offset], args[:limit]
    end

    task :special, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources SpecialHearing, args[:offset], args[:limit]
    end
  end
  
  task :decrees, [:form, :offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources Decree, args[:offset], args[:limit]
  end

  task :court, [:url] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resource Court, args[:url]
  end  
  
  namespace :hearing do
    task :civil, [:url] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resource CivilHearing, args[:url]
    end

    task :criminal, [:url] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resource CriminalHearing, args[:url]
    end

    task :special, [:url] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resource SpecialHearing, args[:url]
    end
  end
end
