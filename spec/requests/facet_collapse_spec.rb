# frozen_string_literal: true

require 'rails_helper'

# The facet-collapse controller posts here when a visitor folds or unfolds a facet; the listing remembers it.
RSpec.describe 'Collapsing facets' do
  def facet_classes
    Capybara.string(response.body).find_by_id('court-type-content', visible: :all)[:class].split
  end

  it 'refuses a listing that does not exist' do
    post collapse_facet_path(model: 'no_such_listing', facet: 'type', collapsed: 'true')

    expect(response).to have_http_status(:unprocessable_content)
  end

  it 'refuses a facet that the listing does not have' do
    post collapse_facet_path(model: 'court', facet: 'no_such_facet', collapsed: 'true')

    expect(response).to have_http_status(:unprocessable_content)
  end

  it 'expands a collapsed facet again on the next pages' do
    post collapse_facet_path(model: 'court', facet: 'type', collapsed: 'true')
    get courts_path

    expect(facet_classes).not_to include('show')

    post collapse_facet_path(model: 'court', facet: 'type', collapsed: 'false')

    expect(response).to have_http_status(:no_content)

    get courts_path

    expect(facet_classes).to include('show')
  end
end
