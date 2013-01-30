# Requires:
# 
# rake resque:workers QUEUE=* COUNT=4
# 
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

    task :decrees, [:decree_form_code] => :environment do |_, args|
      args.with_defaults safe: true
      
      if args[:decree_form_code].blank?
        codes = DecreeForm.all.map { |form| form.code }
      else
        codes = [args[:decree_form_code]]
      end 
      
      codes.each do |code|
        args.to_hash.merge! decree_form_code: code
        JusticeGovSk.run_workers Decree, args
      end
    end
  end
end
