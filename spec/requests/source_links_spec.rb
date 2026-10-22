# frozen_string_literal: true

require 'rails_helper'

# Pages link to the documents their records come from; the addresses are imported data, so only web addresses link.
RSpec.describe 'Source links' do
  def links(path)
    get path

    response.parsed_body.css('a').pluck('href').compact
  end

  it 'links to a source document by its web address' do
    court = create(:court, uri: 'https://www.justice.gov.sk/sudy/1')

    expect(links(court_path(court))).to include('https://www.justice.gov.sk/sudy/1')
  end

  it 'does not link to a source address that is not a web address' do
    court = create(:court, uri: 'javascript:alert(document.cookie)')
    judge = create(:judge, uri: 'javascript:alert(1)')
    hearing = create(:hearing, uri: 'javascript:alert(2)')
    decree = create(:decree, uri: 'javascript:alert(3)', pdf_uri: 'javascript:alert(4)')

    hrefs = [court_path(court), judge_path(judge), hearing_path(hearing), decree_path(decree)].flat_map do |path|
      links(path)
    end

    expect(hrefs).not_to include(a_string_starting_with('javascript:'))
  end
end
