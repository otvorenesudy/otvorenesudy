# encoding: utf-8

namespace :crawl do
  task :courts, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources args.merge type: 'court'
  end
  
  task :judges, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources args.merge type: 'judge'
  end

  namespace :hearings do
    task :civil, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources args.merge type: 'civil_hearing'
    end

    task :criminal, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources args.merge type: 'criminal_hearing'
    end

    task :special, [:offset, :limit] => :environment do |task, args|
      JusticeGovSk::Helpers::CrawlerHelper.crawl_resources args.merge type: 'special_hearing'
    end
  end

  task :decrees, [:offset, :limit] => :environment do |task, args|
    JusticeGovSk::Helpers::CrawlerHelper.crawl_resources args.merge type: 'decree'
  end
end
