# encoding: utf-8

namespace :crawl do
  task :courts, [:offset, :limit] => :environment do |task, args|
    args.with_defaults safe: false
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources Court, args
  end
  
  task :judges, [:offset, :limit] => :environment do |task, args|
    args.with_defaults safe: false
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources Judge, args
  end

  namespace :hearings do
    task :civil, [:offset, :limit] => :environment do |task, args|
      args.with_defaults safe: false
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources CivilHearing, args
    end

    task :criminal, [:offset, :limit] => :environment do |task, args|
      args.with_defaults safe: false
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources CriminalHearing, args
    end

    task :special, [:offset, :limit] => :environment do |task, args|
      args.with_defaults safe: false
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources SpecialHearing, args
    end
  end
  
  task :decrees, [:form, :offset, :limit] => :environment do |task, args|
    args.with_defaults decree_form: args[:form], safe: false
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources Decree, args
  end

  task :court, [:url] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resource Court, args[:url], safe: true
  end  
  
  namespace :hearing do
    task :civil, [:url] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resource CivilHearing, args[:url], safe: true
    end

    task :criminal, [:url] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resource CriminalHearing, args[:url], safe: true
    end

    task :special, [:url] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resource SpecialHearing, args[:url], safe: true
    end
  end
end
