require 'resque/tasks'

namespace :otvorenesudy do 
  namespace :jobs do 
    
    desc "Enqueues jobs for crawling lists"
    task :list_crawlers, [:type, :from,:to] => :environment do |_, args|
      from = args[:from] ? args[:from].to_i : 1
      to   = args[:to]   ? args[:to].to_i   : 1
      type = args[:type]

      raise "No type provided" unless type

      (from..to).each do |page|
        Resque.enqueue(JusticeGovSk::Jobs::ListCrawlerJob, type, page, 1)
      end
    end
  
  end
end

