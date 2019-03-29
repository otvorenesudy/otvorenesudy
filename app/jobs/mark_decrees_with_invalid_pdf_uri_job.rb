class MarkDecreesWithInvalidPdfUriJob
  include Sidekiq::Worker

  sidekiq_options queue: :utils

  def perform(decree_id, decree_pdf_uri)
    response = Curl.get(decree_pdf_uri)

    return if response.response_code == 200 && response.content_type == 'application/octet-stream'

    Decree.where(id: decree_id).update_all(pdf_uri_invalid: true)
  end
end
