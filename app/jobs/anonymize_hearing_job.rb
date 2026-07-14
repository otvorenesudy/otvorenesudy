class AnonymizeHearingJob < ApplicationJob
  queue_as :utils

  def perform(hearing_id)
    Hearing.find(hearing_id).anonymize!
  end
end
