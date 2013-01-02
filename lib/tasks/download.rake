# Examples:
# 
# rake download:courts:pages
# 
# rake download:hearings:civil:pages
# rake download:hearings:criminal:pages
# rake download:hearings:special:pages
# 
# rake download:decrees:pages[F]
# rake download:decrees:documents

namespace :download do
  namespace :courts do
    task :pages, [:offset, :limit] => :environment do |_, args|
      JusticeGovSk.download_pages Court, args
    end
  end
  
  namespace :hearings do
    namespace :civil do
      task :pages, [:offset, :limit] => :environment do |_, args|
        JusticeGovSk.download_pages CivilHearing, args
      end
    end
    
    namespace :criminal do
      task :pages, [:offset, :limit] => :environment do |_, args|
        JusticeGovSk.download_pages CriminalHearing, args
      end
    end
    
    namespace :special do
      task :pages, [:offset, :limit] => :environment do |_, args|
        JusticeGovSk.download_pages SpecialHearing, args
      end
    end
  end

  namespace :decrees do
    task :pages, [:form, :offset, :limit] => :environment do |_, args|
      args.with_defaults decree_form: args[:form]
      JusticeGovSk.download_pages Decree, args
    end

    task :documents do
      JusticeGovSk.download_documents Decree
    end    
  end
end
