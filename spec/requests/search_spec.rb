# frozen_string_literal: true

require 'rails_helper'

# Listing and suggestion URLs as visitors, old links and crawlers send them: params the search can't take as they are
# are read as well as they can be, and never fail the page.
RSpec.describe 'Search' do
  def results
    response.parsed_body.css('.search-result-item').map { |item| item.text.squish }
  end

  describe 'GET /courts' do
    def names
      response.parsed_body.css('.search-result-title > a').map { |link| link.text.squish }
    end

    before do
      create(:court, name: 'Okresný súd Košice I')
      create(:court, name: 'Okresný súd Košice II')
      create(:court, name: 'Okresný súd Bratislava I')
      refresh_indices
    end

    it 'searches the words of a full-text query given as a list' do
      get courts_path(q: %w[Košice I])

      expect(names).to eq(['Okresný súd Košice I'])
    end

    it 'searches the words of a query with an unclosed quote' do
      get courts_path(q: '"Košice I')

      expect(names).to eq(['Okresný súd Košice I'])
    end

    it 'filters by a range open at its start, as the facet links to the lowest one' do
      fined = Court.find_by!(name: 'Okresný súd Bratislava I')
      create(:court_expense, court: fined, value: 5_000)
      Court.find(fined.id).update_index
      refresh_indices

      get courts_path(expenses: '-Infinity..999')

      expect(names).to eq(['Okresný súd Košice I', 'Okresný súd Košice II'])
    end

    it 'ignores a range beyond the numbers the index holds' do
      get courts_path(judges_count: ['3000000000..Infinity'])

      expect(response).to have_http_status(:ok)
      expect(names.size).to eq(3)
    end

    it 'links within the page without the host the request names' do
      get courts_path(q: 'Košice'), headers: { 'X-Forwarded-Host' => 'evil.example' }

      expect(response.parsed_body.at('body').to_html).not_to include('evil.example')
    end
  end

  describe 'GET /hearings' do
    def case_numbers
      results.map { |text| text[%r{\d+C/1/2026}] }
    end

    it 'lists hearings latest first for a sort it does not know' do
      create(:hearing, case_number: '1C/1/2026', date: 1.month.from_now)
      create(:hearing, case_number: '2C/1/2026', date: 2.months.from_now)
      refresh_indices

      get hearings_path(sort: 'no_such_field')

      expect(case_numbers).to eq(%w[2C/1/2026 1C/1/2026])
    end

    it 'finds a hearing by its case number, slashes and all' do
      create(:hearing, case_number: '1C/1/2026')
      create(:hearing, case_number: '2C/1/2026')
      refresh_indices

      get hearings_path(q: '1C/1/2026')

      expect(case_numbers).to eq(['1C/1/2026'])
    end

    it 'ignores a date it cannot read' do
      create(:hearing, case_number: '1C/1/2026')
      refresh_indices

      get hearings_path(date: ['abc..'])

      expect(case_numbers).to eq(['1C/1/2026'])
    end

    it 'ignores a date beyond the years the index holds' do
      create(:hearing, case_number: '1C/1/2026')
      refresh_indices

      get hearings_path(date: ['99999-01-01..99999-01-31'])

      expect(response).to have_http_status(:ok)
      expect(case_numbers).to eq(['1C/1/2026'])
    end
  end

  describe 'GET /decrees' do
    it 'searches a query of only an operator word (OR, the commercial register) for that word' do
      create(:decree, :with_text, case_number: '1Co/1/2026', text: 'Spoločnosť zapísaná v OR Okresného súdu Trnava.')
      create(:decree, :with_text, case_number: '2Co/1/2026', text: 'Obžalovaný sa dopustil krádeže.')
      Decree.find_each(&:update_index)
      refresh_indices

      get decrees_path(q: 'OR')

      expect(response).to have_http_status(:ok)
      expect(results.map { |text| text[%r{\dCo/1/2026}] }).to eq(['1Co/1/2026'])
    end
  end

  describe 'GET /courts/suggest' do
    let(:kosice) { create(:municipality, name: 'Košice') }
    let(:bratislava) { Municipality.find_by!(name: 'Bratislava') }

    # The values offered, without their counts.
    def values(selector = '.facet-item')
      response.parsed_body.css("#{selector} .facet-link").map { |link| link.xpath('text()').text.strip }
    end

    before do
      create(:court, name: 'Krajský súd Košice', municipality: kosice, type: CourtType.regional)
      create(:court, name: 'Okresný súd Bratislava I', municipality: bratislava)
      refresh_indices
    end

    it 'offers the most frequent values for an empty term' do
      get suggest_courts_path(facet: 'municipality', term: '')

      expect(values).to contain_exactly('Bratislava', 'Košice')
    end

    it 'keeps the selected values listed while narrowing the others to the typed term' do
      get suggest_courts_path(facet: 'municipality', term: 'kos', municipality: ['Bratislava'])

      expect(values).to eq(%w[Bratislava Košice])
      expect(values('.facet-item.active')).to eq(['Bratislava'])
    end

    it 'offers the values within the full-text search' do
      get suggest_courts_path(facet: 'municipality', term: '', q: 'Krajský')

      expect(values).to eq(['Košice'])
    end

    it 'answers nothing for a facet it does not know' do
      get suggest_courts_path(facet: 'no_such_facet', term: 'kos')

      expect(response).to have_http_status(:ok)
      expect(response.body).to be_empty
    end

    it 'answers nothing for a facet that takes no suggestions' do
      get suggest_courts_path(facet: 'judges_count', term: '5')

      expect(response).to have_http_status(:ok)
      expect(response.body).to be_empty
    end
  end
end
