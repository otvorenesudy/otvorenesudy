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
  task :decrees, [:maximum_number_of_pages] => :environment do |_, args|
    args.with_defaults safe: true
    privileged = [DecreeForm.find_by_code('P')]

    codes = (privileged + DecreeForm.where('id != ?', privileged.map(&:id)).order(:id).all).map { |form| form.code }

    args.to_hash.merge!(queue: :daily) if args[:maximum_number_of_pages]

    codes.each do |code|
      args.to_hash.merge! decree_form_code: code
      JusticeGovSk.run_workers Decree, args
    end
  end
end
