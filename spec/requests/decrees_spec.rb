# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Decrees' do
  describe 'GET /decrees/:id/document' do
    let(:decree) { create(:decree, pdf_uri: 'https://obcan.justice.sk/decree/1.pdf') }

    it 'serves the decree document from its source' do
      pdf = file_fixture('decree.pdf').binread
      stub_request(:get, 'https://obcan.justice.sk/decree/1.pdf')
        .to_return(status: 200, body: pdf, headers: { 'Content-Type' => 'application/pdf' })

      get document_decree_path(decree)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('application/pdf')
      expect(response.body.b).to eq(pdf)
      expect(response.headers['Content-Disposition']).to include("Rozhodnutie%20%E2%80%94%20##{decree.id}.pdf")
    end

    it 'follows the source to where it moved the document' do
      pdf = file_fixture('decree.pdf').binread
      stub_request(:get, 'https://obcan.justice.sk/decree/1.pdf')
        .to_return(status: 302, headers: { 'Location' => '/content/1.pdf' })
      stub_request(:get, 'https://obcan.justice.sk/content/1.pdf')
        .to_return(status: 200, body: pdf, headers: { 'Content-Type' => 'application/pdf' })

      get document_decree_path(decree)

      expect(response).to have_http_status(:ok)
      expect(response.body.b).to eq(pdf)
    end

    it 'answers bad gateway when the source keeps redirecting' do
      stub_request(:get, 'https://obcan.justice.sk/decree/1.pdf')
        .to_return(status: 302, headers: { 'Location' => 'https://obcan.justice.sk/decree/1.pdf' })

      get document_decree_path(decree)

      expect(response).to have_http_status(:bad_gateway)
      expect(a_request(:get, 'https://obcan.justice.sk/decree/1.pdf')).to have_been_made.times(4)
    end

    it 'answers bad gateway when the source does not serve it' do
      stub_request(:get, 'https://obcan.justice.sk/decree/1.pdf').to_return(status: 404)

      get document_decree_path(decree)

      expect(response).to have_http_status(:bad_gateway)
    end

    it 'answers bad gateway when the source does not answer' do
      stub_request(:get, 'https://obcan.justice.sk/decree/1.pdf').to_timeout

      get document_decree_path(decree)

      expect(response).to have_http_status(:bad_gateway)
    end

    it 'is not found for a decree without a document' do
      decree.update!(pdf_uri: nil)

      get document_decree_path(decree)

      expect(response).to have_http_status(:not_found)
    end
  end
end
