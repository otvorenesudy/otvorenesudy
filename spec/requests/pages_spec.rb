# frozen_string_literal: true

require 'rails_helper'
require 'sentry/test_helper'

RSpec.describe 'Pages' do
  include Sentry::TestHelper

  it 'redirects the API page to the API site in the current language' do
    get static_page_path('api', l: :en)

    expect(response).to redirect_to('https://api.otvorenesudy.sk?l=en')
  end

  describe 'GET /health' do
    it 'answers when the index holds every court, judge, hearing and decree' do
      create(:court)
      refresh_indices

      get health_path

      expect(response).to have_http_status(:no_content)
    end

    it 'names the model whose index count differs from the database' do
      court = create(:court)
      Court.client.delete(index: Court.index_name, id: court.id, refresh: true)

      get health_path

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body).to eq('errors' => ['Court count does not match'])
    end
  end

  it 'renders a listing whose search has invalid UTF-8' do
    get '/courts?q=%FF'

    expect(response).to have_http_status(:ok)
  end

  context 'when the search fails', :error_pages do
    before { setup_sentry_test }

    after { teardown_sentry_test }

    it 'shows the error page and reports the error to Sentry' do
      stub_request(:post, %r{\Ahttp://localhost:9200/courts_test/_search})
        .to_return(status: 500, body: '{}', headers: { 'content-type' => 'application/json',
                                                       'x-elastic-product' => 'Elasticsearch' })

      get courts_path

      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include(I18n.t('exceptions.internal_server_error.title'))
      expect(sentry_events.size).to eq(1)
    end
  end
end
