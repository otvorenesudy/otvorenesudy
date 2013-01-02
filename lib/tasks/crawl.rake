# Examples:
# 
# rake crawl:courts
# 
# rake crawl:judges
# 
# rake crawl:hearings:civil
# rake crawl:hearings:criminal
# rake crawl:hearings:special
# 
# rake crawl:decrees[F]

namespace :crawl do
  task :courts, [:offset, :limit] => :environment do |_, args|
    args.with_defaults safe: false
    JusticeGovSk.crawl_resources Court, args
  end
  
  task :judges, [:offset, :limit] => :environment do |_, args|
    args.with_defaults safe: false
    JusticeGovSk.crawl_resources Judge, args
  end

  namespace :hearings do
    task :civil, [:offset, :limit] => :environment do |_, args|
      args.with_defaults safe: false
      JusticeGovSk.crawl_resources CivilHearing, args
    end

    task :criminal, [:offset, :limit] => :environment do |_, args|
      args.with_defaults safe: false
      JusticeGovSk.crawl_resources CriminalHearing, args
    end

    task :special, [:offset, :limit] => :environment do |_, args|
      args.with_defaults safe: false
      JusticeGovSk.crawl_resources SpecialHearing, args
    end
  end
  
  task :decrees, [:form, :offset, :limit] => :environment do |_, args|
    args.with_defaults decree_form: args[:form], safe: false
    JusticeGovSk.crawl_resources Decree, args
  end
  
  task :court, [:url] => :environment do |_, args|
    JusticeGovSk.crawl_resource Court, args[:url], safe: true
  end  
  
  namespace :hearing do
    task :civil, [:url] => :environment do |_, args|
      JusticeGovSk.crawl_resource CivilHearing, args[:url], safe: true
    end

    task :criminal, [:url] => :environment do |_, args|
      JusticeGovSk.crawl_resource CriminalHearing, args[:url], safe: true
    end

    task :special, [:url] => :environment do |_, args|
      JusticeGovSk.crawl_resource SpecialHearing, args[:url], safe: true
    end
  end
  
  task :decree, [:url, :form] => :environment do |_, args|
    args.with_defaults decree_form: args[:form], safe: true
    JusticeGovSk.crawl_resource Decree, args[:url], args
  end
end
