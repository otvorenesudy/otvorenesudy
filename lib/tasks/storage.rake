# Usage:
# 
# rake storage:distribute['storage/pages/courts','storage/pages/courts-distributed']
# rake storage:merge['storage/pages/hearings/special','storage/pages/hearings/special-merged']
# 
# rake storage:stat[storage/pages/decrees]
# 
# rake storage:validate:pages[storage/pages/decrees]
# rake storage:validate:documents[storage/documents/decrees]

namespace :storage do
  desc "Copy standard storage into distributed storage"
  task :distribute, [:src, :dst, :verbose] => :environment do |_, args|
    args.with_defaults verbose: false
    Core::Storage::Utils.distribute args[:src], args[:dst], args
  end
  
  desc "Copy distributed storage into standard storage"
  task :merge, [:src, :dst, :verbose] => :environment do |_, args|
    args.with_defaults verbose: false
    Core::Storage::Utils.merge args[:src], args[:dst], args
  end
  
  desc "Compute size statistics of distributed storage"
  task :stat, [:src, :verbose] => :environment do |_, args|
    Core::Storage::Utils.stat args[:src], args
  end
  
  namespace :validate do
    desc "Check if distributed storage contains only proper HTML pages"
    task :pages, [:src, :verbose] => :environment do |_, args|
      include JusticeGovSk::Helper::ContentValidator
      
      Core::Storage::Utils.validate args[:src], args do |path|
        hearing_html?(path) || decree_html?(path)
      end
    end
    
    desc "Check if distributed storage contains only PDF documents"
    task :documents, [:src, :verbose] => :environment do |_, args|
      include JusticeGovSk::Helper::ContentValidator
      
      Core::Storage::Utils.validate args[:src], args do |path|
        decree_pdf?(path)
      end
    end
  end
end
