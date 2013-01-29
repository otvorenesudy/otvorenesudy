# Examples:
# 
# rake run:crawlers:hearings:civil
# rake run:crawlers:hearings:criminal
# rake run:crawlers:hearings:special
# 
# rake run:crawlers:decrees[F]

namespace :run do
  namespace :crawlers do
    namespace :hearings do
      task :civil => :environment do
        JusticeGovSk.run_workers CivilHearing, safe: true 
      end
 
      task :criminal => :environment do
        JusticeGovSk.run_workers CriminalHearing, safe: true
      end

      task :special => :environment do
        JusticeGovSk.run_workers SpecialHearing, safe: true
      end
    end

    task :decrees, [:form] => :environment do |_, args|
      args.with_defaults decree_form_code: args[:form], safe: true
      JusticeGovSk.run_workers Decree, args
    end
  end
end
