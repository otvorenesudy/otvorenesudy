# frozen_string_literal: true

# Reindexes a record otvorenesudy-api just imported or updated. The API pushes this job straight into Redis
# (UpdateNotifier: {'class' => 'UpdateRepositoryJob', 'queue' => 'probe', 'args' => [model_name, id]}), so it stays a
# plain Sidekiq job with this name, queue and arguments; changing any of them means changing the API too.
class UpdateRepositoryJob
  include Sidekiq::Job

  sidekiq_options queue: :probe

  MODELS = %w[Decree Court Hearing Judge].freeze

  def perform(model_name, id)
    return unless MODELS.include?(model_name)

    model_name.constantize.find_by(id:)&.update_index
  end
end
