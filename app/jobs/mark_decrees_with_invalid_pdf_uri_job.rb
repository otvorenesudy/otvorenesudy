# frozen_string_literal: true

# Marks decrees whose PDF the source no longer serves: anything but a 200 with a binary body.
class MarkDecreesWithInvalidPdfUriJob < ApplicationJob
  queue_as :utils

  def perform(records)
    records.each do |id, uri|
      next if serves_pdf?(uri)

      # A flag outside the index: no validations or reindexing callbacks to run.
      Decree.where(id:).update_all(pdf_uri_invalid: true) # rubocop:disable Rails/SkipsModelValidations
    end
  end

  private

  def serves_pdf?(uri)
    uri = URI(uri)

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: 10, read_timeout: 30) do |http|
      response = http.request_head(uri)
      response = http.request_get(uri) if response.is_a?(Net::HTTPMethodNotAllowed)

      response.is_a?(Net::HTTPOK) && response.content_type == 'application/octet-stream'
    end
  rescue StandardError
    false
  end
end
