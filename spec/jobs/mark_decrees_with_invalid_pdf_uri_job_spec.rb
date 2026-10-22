# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarkDecreesWithInvalidPdfUriJob do
  let(:decree) { create(:decree, pdf_uri: 'https://obcan.justice.sk/decree/1.pdf') }

  def check
    described_class.perform_now([[decree.id, decree.pdf_uri]])
  end

  it 'keeps a decree whose source serves its PDF' do
    stub_request(:get, decree.pdf_uri).to_return(status: 200, headers: { 'Content-Type' => 'application/octet-stream' })

    check

    expect(decree.reload).to be_pdf_uri_valid
  end

  it 'marks a decree whose source no longer serves its PDF' do
    stub_request(:get, decree.pdf_uri).to_return(status: 404)

    check

    expect(decree.reload).not_to be_pdf_uri_valid
  end

  it 'marks a decree whose source serves a page instead of the PDF' do
    stub_request(:get, decree.pdf_uri).to_return(status: 200, headers: { 'Content-Type' => 'text/html' })

    check

    expect(decree.reload).not_to be_pdf_uri_valid
  end

  it 'marks a decree whose PDF address is not an address' do
    decree.update_column(:pdf_uri, 'https://obcan justice.sk/1.pdf') # rubocop:disable Rails/SkipsModelValidations -- as imported

    check

    expect(decree.reload).not_to be_pdf_uri_valid
  end

  it 'marks a decree without a PDF address or with one that is not on the web, and checks the rest of the batch' do
    missing = create(:decree, pdf_uri: nil)
    local = create(:decree, pdf_uri: 'file:///etc/passwd')
    stub_request(:get, decree.pdf_uri).to_return(status: 200, headers: { 'Content-Type' => 'application/octet-stream' })

    described_class.perform_now([[missing.id, nil], [local.id, local.pdf_uri], [decree.id, decree.pdf_uri]])

    expect(Decree.where(pdf_uri_invalid: true)).to contain_exactly(missing, local)
    expect(decree.reload).to be_pdf_uri_valid
  end

  it 'fails, to be retried, when the source does not answer' do
    stub_request(:get, decree.pdf_uri).to_timeout

    expect { check }.to raise_error(Net::OpenTimeout)
    expect(decree.reload).to be_pdf_uri_valid
  end
end
