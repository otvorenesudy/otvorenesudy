# frozen_string_literal: true

module Probe
  # Rebuilds a model's index in the background (`bin/rails probe:import`).
  class ReindexJob < ApplicationJob
    queue_as :probe

    def perform(model_name)
      model = Probe.models.find { |candidate| candidate.name == model_name }

      raise ArgumentError, "#{model_name} isn't searchable" unless model

      model.reindex
    end
  end
end
