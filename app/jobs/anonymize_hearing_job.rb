class AnonymizeHearingJob
  include Sidekiq::Worker

  sidekiq_options queue: :utils

  def perform(hearing_id)
    Hearing.find(hearing_id).anonymize!
  end
end
