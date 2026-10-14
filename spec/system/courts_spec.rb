# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Courts' do
  let(:bratislava) { Municipality.find_by!(name: 'Bratislava') }
  let(:kosice) { create(:municipality, name: 'Košice') }

  # Headings are uppercase on screen (CSS), so a browser reads them uppercase.
  def heading(text)
    /\A#{Regexp.escape(text)}\z/i
  end

  def facet(title)
    find('.facet-title', text: heading(title)).ancestor('.facet')
  end

  def result_names
    all('.search-result-title > a').map(&:text)
  end

  describe 'the listing' do
    it 'lists courts by name, 20 a page, with their count' do
      25.times { |n| create(:court, name: format('Okresný súd %02d', n + 1)) }
      refresh_indices

      visit courts_path

      expect(result_names.first(3)).to eq(['Okresný súd 01', 'Okresný súd 02', 'Okresný súd 03'])
      expect(result_names.size).to eq(20)
      expect(page).to have_text('1 – 20 z celkovo 25 výsledkov')

      within('.pagination') { click_on '2' }

      expect(result_names).to eq((21..25).map { |n| format('Okresný súd %02d', n) })
    end

    it 'finds courts regardless of diacritics and case' do
      create(:court, name: 'Okresný súd Košice I', municipality: kosice)
      create(:court, name: 'Okresný súd Bratislava I', municipality: bratislava)
      refresh_indices

      visit courts_path
      fill_in 'q', with: 'kosice'
      find('.search-query-submit').click

      expect(result_names).to eq(['Okresný súd Košice I'])
    end

    it 'filters by a facet value and counts the other facets within it' do
      create(:court, name: 'Krajský súd Košice', municipality: kosice, type: CourtType.regional)
      create(:court, name: 'Okresný súd Košice I', municipality: kosice)
      create(:court, name: 'Okresný súd Bratislava I', municipality: bratislava)
      refresh_indices

      visit courts_path
      within(facet('Typ')) { click_on 'Okresný' }

      expect(result_names).to eq(['Okresný súd Bratislava I', 'Okresný súd Košice I'])
      expect(facet('Typ')).to have_css('.facet-item.active', text: 'Okresný')
      expect(facet('Typ')).to have_css('.facet-item', text: 'Krajský')
      expect(facet('Obec')).to have_css('.facet-item', text: /Košice\s*1/)

      within(facet('Typ')) { click_on 'Okresný' }

      expect(result_names.size).to eq(3)
    end

    it 'ORs values within a facet and ANDs facets' do
      create(:court, name: 'Krajský súd Košice', municipality: kosice, type: CourtType.regional)
      create(:court, name: 'Okresný súd Košice I', municipality: kosice)
      create(:court, name: 'Okresný súd Bratislava I', municipality: bratislava)
      refresh_indices

      visit courts_path(type: %w[Okresný Krajský])

      expect(result_names.size).to eq(3)

      visit courts_path(type: %w[Okresný], municipality: %w[Košice])

      expect(result_names).to eq(['Okresný súd Košice I'])
    end

    it 'filters by a range of judges' do
      large = create(:court, name: 'Okresný súd Veľký')
      create(:court, name: 'Okresný súd Malý')
      create_list(:employment, 6, court: large)
      large.update_index
      refresh_indices

      visit courts_path
      within(facet('Počet sudcov')) { click_on '5 až 10' }

      expect(result_names).to eq(['Okresný súd Veľký'])
    end

    it 'offers the courts fined more than the largest range' do
      fined = create(:court, name: 'Okresný súd Pokutovaný')
      create(:court, name: 'Okresný súd Bez pokút')
      create(:court_expense, court: fined, value: 150_000)
      Court.find(fined.id).update_index
      refresh_indices

      visit courts_path
      within(facet('Pokuty')) { find('.facet-link', text: /Viac ako 100[[:space:]]000[[:space:]]€/).click }

      expect(result_names).to eq(['Okresný súd Pokutovaný'])
    end

    it 'names the chair and the vice-chair of each court' do
      both = create(:court, name: 'Okresný súd Košice I')
      create(:employment, court: both, judge: create(:judge, first: 'Ján', last: 'Predseda'),
                          judge_position: JudgePosition.create!(value: 'predseda'))
      create(:employment, court: both, judge: create(:judge, first: 'Eva', last: 'Zástupcová'),
                          judge_position: JudgePosition.create!(value: 'podpredsedníčka'))
      vice = create(:court, name: 'Okresný súd Prešov')
      create(:employment, court: vice, judge: create(:judge, first: 'Juraj', last: 'Zástupca'),
                          judge_position: JudgePosition.create!(value: 'podpredseda'))
      refresh_indices

      visit courts_path

      expect(page).to have_text('Predseda súdu je JUDr. Ján Predseda a podpredsedníčka je JUDr. Eva Zástupcová.')
      expect(page).to have_text('Podpredseda súdu je JUDr. Juraj Zástupca.')
    end

    it 'sorts by the chosen field and order, and falls back to the name for an unknown one' do
      create(:court, name: 'Okresný súd A')
      busy = create(:court, name: 'Okresný súd B')
      create_list(:employment, 3, court: busy)
      busy.update_index
      refresh_indices

      visit courts_path(sort: 'judges_count', order: 'desc')

      expect(result_names).to eq(['Okresný súd B', 'Okresný súd A'])

      visit courts_path(sort: 'no_such_field')

      expect(result_names).to eq(['Okresný súd A', 'Okresný súd B'])
    end

    it 'says when nothing matches' do
      create(:court)
      refresh_indices

      visit courts_path(q: 'neexistujúci')

      expect(page).to have_text(I18n.t('search.results.no_results'))
      expect(page).to have_css('.facet', text: 'Typ')
    end

    it 'shows the last reachable page for a page beyond the results' do
      create(:court, name: 'Okresný súd Jediný')
      refresh_indices

      visit courts_path(page: 100_000)

      expect(page).to have_http_status(:ok)
    end
  end

  describe 'facets in the browser', :js do
    it 'narrows a facet to the values containing the typed text, regardless of diacritics' do
      create(:court, name: 'Okresný súd Košice I', municipality: kosice)
      create(:court, name: 'Okresný súd Bratislava I', municipality: bratislava)
      refresh_indices

      visit courts_path
      within(facet('Obec')) { fill_in 'municipality', with: 'kos' }

      expect(facet('Obec')).to have_css('.facet-item', text: 'Košice')
      expect(facet('Obec')).to have_no_css('.facet-item', text: 'Bratislava')
    end

    it 'keeps a collapsed facet collapsed on the next page' do
      create(:court)
      refresh_indices

      visit courts_path
      find('.facet-title', text: heading('Typ')).click

      expect(page).to have_css('#court-type-content:not(.show):not([aria-busy])', visible: :all)

      visit courts_path

      expect(page).to have_css('#court-type-content:not(.show)', visible: :all)
    end

    it 'shortens a long value and shows it in full on hover' do
      create(:court, municipality: create(:municipality, name: 'Spišská Nová Ves – Novoveská Huta'))
      refresh_indices

      visit courts_path
      within(facet('Obec')) { find('.facet-link', text: /Novoveská…/).hover }

      expect(page).to have_css('.tooltip', text: 'Spišská Nová Ves – Novoveská Huta')
    end
  end

  describe 'a court' do
    let(:court) do
      create(:court, name: 'Okresný súd Košice I', municipality: kosice, street: 'Štúrova 29', phone: '055/6801 111')
    end

    it 'shows its address, judges and contacts' do
      chair = create(:judge, first: 'Ján', last: 'Predseda')
      create(:employment, court:, judge: chair, judge_position: JudgePosition.create!(value: 'predseda'))
      create(:employment, court:, judge: create(:judge, first: 'Eva', last: 'Aktívna'))
      create(:employment, :inactive, court:, judge: create(:judge, first: 'Juraj', last: 'Bývalý'))

      visit court_path(court)

      expect(page).to have_css('h1', text: 'Okresný súd Košice I')
      expect(page).to have_text('Štúrova 29')
      expect(page).to have_link('Ján Predseda')
      expect(page).to have_link('Eva Aktívna')
      expect(page).to have_link('Juraj Bývalý')
    end

    it 'lists each judge once: active ones first, then the others' do
      create(:employment, court:, judge: create(:judge, first: 'Eva', last: 'Aktívna'))
      create(:employment, :inactive, court:, judge: create(:judge, first: 'Juraj', last: 'Bývalý'))

      visit court_path(court)

      tables = all('#judges table')

      expect(tables.size).to eq(2)
      expect(tables.first).to have_link('Eva Aktívna')
      expect(tables.first).to have_no_link('Juraj Bývalý')
      expect(tables.last).to have_link('Juraj Bývalý')
      expect(tables.last).to have_no_link('Eva Aktívna')
    end

    it 'ranks its expenses among courts of its type' do
      create(:court_expense, court:, value: 30_000)
      create(:court_expense, court: create(:court), value: 10_000)

      visit court_path(court)

      expect(page).to have_text('30 000')
    end

    it 'ranks the average durations of its proceedings among the district courts' do
      bardejov = create(:court, name: 'Okresný súd Bardejov')
      create(:court, name: 'Okresný súd Banská Bystrica')

      visit court_path(bardejov)

      expect(page).to have_link('Občiansko-právne')

      within('#proceedings-C') do
        expect(page).to have_text('Celkovo 1. najpomalší súd z 2 okresných súdov v rámci agendy Občiansko-právne:')
        expect(page).to have_text('Priemerná dĺžka za rok 2013 je 15,1 mesiaca')
      end
    end

    it 'ranks it together with a court of equal expenses' do
      create(:court_expense, court:, value: 20_000)
      create(:court_expense, court: create(:court), value: 20_000)

      visit court_path(court)

      expect(page).to have_text('Celkovo 1. až 2.')
    end

    it 'links each of its e-mail addresses' do
      court.update!(data_protection_email: 'gdpr@justice.sk, podatelna@justice.sk')

      visit court_path(court)

      expect(page).to have_link('gdpr@justice.sk', href: 'mailto:gdpr@justice.sk')
      expect(page).to have_link('podatelna@justice.sk', href: 'mailto:podatelna@justice.sk')
    end

    it 'lists a judge of unknown activity as probably a higher court official' do
      create(:employment, :unknown, court:, judge: create(:judge, first: 'Mária', last: 'Úradníčková'))

      visit court_path(court)

      within('#judges') do
        expect(page).to have_text('pravdepodobne VSÚ')
        expect(find_link('VSÚ', class: 'text-muted')['data-bs-title']).to eq('Vyššia súdna úradníčka')
      end
    end

    it 'shows its headings in English' do
      visit court_path(court, l: :en)

      expect(page).to have_css('h1', text: 'Okresný súd Košice I')
      expect(page).to have_css('.nav-tabs', text: I18n.t('courts.show.judges', locale: :en))
    end

    it 'shows the not found page for a court that does not exist', :error_pages do
      visit court_path(id: 0)

      expect(page).to have_http_status(:not_found)
      expect(page).to have_css('h1', text: I18n.t('exceptions.not_found.title'))
    end
  end

  describe 'a court in the browser', :js do
    let(:court) { create(:court, name: 'Okresný súd Košice I') }

    it 'opens the tab named in the address' do
      visit court_path(court, anchor: 'judges')

      expect(page).to have_css('#judges.active.show')
    end

    it 'sorts its judges by name regardless of diacritics' do
      %w[Čierny Cibuľa Bobek].each { |last| create(:employment, court:, judge: create(:judge, last:)) }

      visit court_path(court, anchor: 'judges')
      within('#judges') { find('th', text: heading(I18n.t('courts.judges.list.name'))).click }

      names = within('#judges') { all('tbody tr td:nth-child(3)').map(&:text) }

      expect(names.map { |name| name.split.last }).to eq(%w[Bobek Cibuľa Čierny])
    end
  end
end
