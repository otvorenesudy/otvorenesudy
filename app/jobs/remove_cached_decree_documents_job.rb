class RemoveCachedDecreeDocumentsJob
  include Sidekiq::Worker

  sidekiq_options queue: :utils

  def perform(decree_id)
    decree = Decree.find(decree_id)
    response = Curl.get(decree.pdf_uri)

    if response.response_code == 200 && response.content_type == 'application/octet-stream'
      FileUtils.rm_f(Rails.root.join(decree.document_path))
    end
  end
end
