# frozen_string_literal: true

class DestroyModelJob < ApplicationJob
  queue_as :utils

  def perform(model_name, id)
    model = model_name.safe_constantize

    raise ArgumentError, "#{model_name} isn't a model" unless model.is_a?(Class) && model < ApplicationRecord

    model.find(id).destroy
  end
end
