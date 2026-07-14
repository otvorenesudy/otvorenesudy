class DestroyModelJob < ApplicationJob
  queue_as :utils

  def perform(model, id)
    model.constantize.find(id).destroy
  end
end
