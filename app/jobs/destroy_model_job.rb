class DestroyModelJob
  include Sidekiq::Worker

  sidekiq_options queue: :utils

  def perform(model, id)
    model.constantize.find(id).destroy!
  end
end
