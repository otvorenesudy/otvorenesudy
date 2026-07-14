class UpdateRepositoryJob < ApplicationJob
  queue_as :probe

  def perform(model_name, id)
    return unless model_name.in? %w[Decree Court Hearing Judge]

    model_name.constantize.find(id).update_index
  end
end
