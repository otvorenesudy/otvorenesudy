class MarkDecreesWithInvalidPdfUriJob
  include Sidekiq::Worker

  sidekiq_options queue: :utils

  def perform(records)
    records.each do |(id, uri)|
      response = Curl.get(uri)

      next if response.response_code == 200 && response.content_type == 'application/octet-stream'

      Decree.where(id: id).update_all(pdf_uri_invalid: true)
    end
  end
end
