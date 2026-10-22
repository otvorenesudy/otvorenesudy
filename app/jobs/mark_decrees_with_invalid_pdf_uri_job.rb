# frozen_string_literal: true

require 'net/http'

# Marks decrees whose PDF the source no longer serves: anything but a 200 with a binary body. A network failure fails
# the job, to be retried, rather than mark the decrees.
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

  # An address that is missing or not on the web (file:, a relative path) serves nothing.
  def serves_pdf?(url)
    uri = URI(url.to_s)
    return false unless uri.is_a?(URI::HTTP) && uri.host.present?

    options = { use_ssl: uri.scheme == 'https', open_timeout: 10, read_timeout: 60 }
    response = Net::HTTP.start(uri.host, uri.port, **options) { |http| http.request_get(uri) }

    response.is_a?(Net::HTTPOK) && response.content_type == 'application/octet-stream'
  rescue URI::InvalidURIError
    false
  end
end
