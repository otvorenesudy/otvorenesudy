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
    desc "Download HTML pages of courts from justice.gov.sk"
    task :pages, [:offset, :limit] => :environment do |_, args|
      args.with_defaults safe: false
      JusticeGovSk.download_pages Court, args
    end
  end
  
  namespace :hearings do
    namespace :civil do
      desc "Download HTML pages of civil hearings from justice.gov.sk"
      task :pages, [:offset, :limit] => :environment do |_, args|
        args.with_defaults safe: false
        JusticeGovSk.download_pages CivilHearing, args
      end
    end
    
    namespace :criminal do
      desc "Download HTML pages of criminal hearings from justice.gov.sk"
      task :pages, [:offset, :limit] => :environment do |_, args|
        args.with_defaults safe: false
        JusticeGovSk.download_pages CriminalHearing, args
      end
    end
    
    namespace :special do
      desc "Download HTML pages of special hearings from justice.gov.sk"
      task :pages, [:offset, :limit] => :environment do |_, args|
        args.with_defaults safe: false
        JusticeGovSk.download_pages SpecialHearing, args
      end
    end
  end

  namespace :decrees do
    desc "Download HTML pages of decrees from justice.gov.sk"
    task :pages, [:decree_form_code, :offset, :limit] => :environment do |_, args|
      args.with_defaults safe: false
      JusticeGovSk.download_pages Decree, args
    end

    desc "Download PDF documents of decrees from justice.gov.sk"
    task :documents => :environment do
      JusticeGovSk.download_documents Decree, safe: false
    end    
  end
end
