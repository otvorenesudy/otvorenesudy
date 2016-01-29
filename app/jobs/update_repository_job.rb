class UpdateRepositoryJob
  include Sidekiq::Worker

  sidekiq_options queue: :probe

  def perform(model_name, id)
    return unless model_name.in? ['Decree', 'Court', 'Hearing', 'Judge']

    model_name.constantize.find(id).update_index
  end
end
