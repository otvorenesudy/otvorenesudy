# Requires:
#
# rake resque:workers QUEUE=* COUNT=4
#
# Usage:
#
# rake work:hearings:civil
# rake work:hearings:criminal
# rake work:hearings:special
#
# rake work:decrees
# rake work:decrees[F]

namespace :work do
  namespace :hearings do
    desc "Start Resque jobs for crawling civil hearings from justice.gov.sk"
    task civil: :environment do
      JusticeGovSk.run_workers CivilHearing, safe: true
    end

    desc "Start Resque jobs for crawling criminal hearings from justice.gov.sk"
    task criminal: :environment do
      JusticeGovSk.run_workers CriminalHearing, safe: true
    end

    desc "Start Resque jobs for crawling special hearings from justice.gov.sk"
    task special: :environment do
      JusticeGovSk.run_workers SpecialHearing, safe: true
    end
  end

  desc "Start Resque jobs for crawling decrees from justice.gov.sk"
  task :decrees, [:decree_form_code] => :environment do |_, args|
    args.with_defaults safe: true

    if args[:decree_form_code].blank?
      other = DecreeForm.find_by_code('P')

      codes = ([other] + DecreeForm.where('id != ?', other.id).order(:id).all).map { |form| form.code }
    else
      codes = [args[:decree_form_code]]
    end

    codes.each do |code|
      args.to_hash.merge! decree_form_code: code
      JusticeGovSk.run_workers Decree, args
    end
  end
end
