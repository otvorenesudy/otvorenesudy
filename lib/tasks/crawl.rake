# encoding: utf-8

namespace :crawl do
  task :courts, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources Court, { safe: false }.merge(args)
  end
  
  task :judges, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources Judge, { safe: false }.merge(args)
  end

  namespace :hearings do
    task :civil, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources CivilHearing, { safe: false }.merge(args)
    end

    task :criminal, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources CriminalHearing, { safe: false }.merge(args)
    end

    task :special, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources SpecialHearing, { safe: false }.merge(args)
    end
  end
  
  task :decrees, [:form, :offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources Decree, { safe: false }.merge(args)
  end

  task :court, [:url] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resource Court, args[:url], args
  end  
  
  namespace :hearing do
    task :civil, [:url] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resource CivilHearing, args[:url], args
    end

    task :criminal, [:url] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resource CriminalHearing, args[:url], args
    end

    task :special, [:url] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resource SpecialHearing, args[:url], args
    end
  end
end
