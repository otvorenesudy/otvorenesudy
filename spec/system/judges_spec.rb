# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Judges' do
  let(:court) { create(:court, name: 'Okresný súd Rimavská Sobota') }

  # Headings are uppercase on screen (CSS), so a browser reads them uppercase.
  def heading(text)
    /\A#{Regexp.escape(text)}\z/i
  end

  def facet(title)
    find('.facet-title', text: heading(title)).ancestor('.facet')
  end

  def result_names
    all('.search-result-title > a:first-child').map(&:text)
  end

  # A judge employed at the court, indexed with the employment.
  def judge(last, first: 'Peter', **attributes)
    create(:judge, first:, last:, **attributes).tap do |judge|
      create(:employment, court:, judge:)
      judge.update_index
    end
  end

  # The indicator datasets match judges by id (or name, 2013) when first read; read them again for these judges.
  def index_with_indicators(*judges)
    [Judge::Indicators2013, Judge::Indicators2015, Judge::Indicators2017].each { |year| year::DATASET.reset! }
    Judge::Indicators2021.reset!
    judges.each(&:update_index)
    refresh_indices
  end

  describe 'the listing' do
    it 'lists judges by surname regardless of diacritics, with their employments' do
      %w[Dobos Čierny Adamec].each { |last| judge(last) }
      refresh_indices

      visit judges_path

      expect(result_names).to eq(['JUDr. Peter Adamec', 'JUDr. Peter Čierny', 'JUDr. Peter Dobos'])
      expect(page).to have_css('.search-result-item', text: 'Okresný súd Rimavská Sobota', count: 3)
    end

    it 'finds a judge by the beginning of a name, without diacritics' do
      judge('Čierny')
      judge('Adamec')
      refresh_indices

      visit judges_path
      fill_in 'q', with: 'cier'
      find('.search-query-submit').click

      expect(result_names).to eq(['JUDr. Peter Čierny'])
    end

    it 'filters by activity and by court' do
      judge('Aktívny')
      create(:employment, :inactive, judge: create(:judge, last: 'Bývalý'), court: create(:court, name: 'Krajský súd'))
      Judge.find_by!(last: 'Bývalý').update_index
      refresh_indices

      visit judges_path
      within(facet('Aktivita')) { click_on 'Neaktívny' }

      expect(result_names).to eq(['JUDr. Peter Bývalý'])

      visit judges_path
      within(facet('Súd')) { click_on 'Okresný súd Rimavská Sobota' }

      expect(result_names).to eq(['JUDr. Peter Aktívny'])
    end
  end

  describe 'a judge' do
    it 'shows their employments with the hearings and decrees counted' do
      chair = judge('Predseda')
      chair.employments.first.update!(judge_position: JudgePosition.create!(value: 'predseda'), note: 'Dočasne')

      visit judge_path(chair)

      expect(page).to have_css('h1', text: 'JUDr. Peter Predseda')
      expect(page).to have_text('Aktívny predseda na súde Okresný súd Rimavská Sobota')
      expect(page).to have_link('Okresný súd Rimavská Sobota', href: court_path(court, l: :sk))
      expect(page).to have_text('Poznámka: Dočasne.')
    end

    it 'shows their designation, relatives and notes' do
      judge = judge('Novák')
      create(:judge_designation, judge:, date: 10.years.ago.to_date,
                                 type: JudgeDesignationType.create!(value: 'Vymenovanie na neurčito'))
      declaration = create(:judge_property_declaration, judge:, year: 2012)
      create(:judge_related_person, property_declaration: declaration, name: 'Mária Nováková', function: 'manželka',
                                    institution: 'Okresný súd Rimavská Sobota')
      create(:judge_statistical_summary, judge:, court:, substantiation_notes: 'Vysoký nápad vecí')

      visit judge_path(judge)

      expect(page).to have_text('Sudca bol vymenovaný do funkcie pred asi 10 rokmi, vymenovanie na neurčito.')
      expect(page).to have_text('Manželka Mária Nováková, Okresný súd Rimavská Sobota.')
      expect(page).to have_link('Okresný súd Rimavská Sobota', href: court_path(court, l: :sk), count: 2)
      expect(page).to have_text('2012 – Vysoký nápad vecí.')
    end

    it 'warns that data of a judge at a higher court are incomplete' do
      judge = create(:judge, last: 'Najvyšší')
      create(:employment, judge:, court: create(:court, type: CourtType.supreme))

      visit judge_path(judge)

      expect(page).to have_css('.alert', text: I18n.t('judges.show.incomplete'))
    end

    it 'opens the decrees for a judge without indicators' do
      judge = judge('Bezindikátorov')

      visit judge_path(judge)

      expect(page).to have_css('.nav-link.active', text: I18n.t('judges.show.decrees'))
      expect(page).to have_text(I18n.t('judges.decrees.none'))
      expect(page).to have_text(I18n.t('judges.indicators_2017.none'))
    end

    it 'shows the not found page for a judge that does not exist', :error_pages do
      visit judge_path(id: 0)

      expect(page).to have_http_status(:not_found)
    end

    it 'shows its headings in English' do
      judge = judge('Novák')

      visit judge_path(judge, l: :en)

      expect(page).to have_css('.nav-tabs', text: I18n.t('judges.show.decrees', locale: :en))
    end
  end

  describe 'the indicators of a judge' do
    let!(:dalak) { create(:judge, id: 194, first: 'Ivan', last: 'Ďalak', name: 'JUDr. Ivan Ďalak') }
    let!(:zilkova) { create(:judge, id: 1492, first: 'Margita', last: 'Žilková', name: 'JUDr. Margita Žilková') }

    before do
      [dalak, zilkova].each { |judge| create(:employment, court:, judge:) }
      index_with_indicators(dalak, zilkova)
    end

    it 'opens the latest year and evaluates the judge' do
      visit judge_path(dalak)

      expect(page).to have_css('.nav-link.active', text: I18n.t('judges.show.indicators', year: 2021))
      expect(page).to have_text(I18n.t('judges.indicators_2021.evaluation_values.výborné'))
      expect(page).to have_css('#indicators-2021 .chart-legend',
                               text: I18n.t('judges.indicators_2021.chart.values.ratio'))
    end

    it 'compares the judge with the average and with another judge' do
      visit judge_path(dalak, anchor: 'indicators-2017')

      within('#indicators-2017') do
        expect(page).to have_css('.chart-legend', text: /Priemer.*JUDr\. Ivan Ďalak/m)

        within(facet(I18n.t('judges.indicators_2013.numerical.additional_judges'))) { click_on 'JUDr. Margita Žilková' }
      end

      expect(page).to have_current_path(/name/)
      expect(find('#indicators-2017 .chart-legend')).to have_text(/JUDr\. Ivan Ďalak.*JUDr\. Margita Žilková/m)
    end
  end

  describe 'the 2017 indicators of a judge deciding mostly criminal cases' do
    it 'names the agenda' do
      gallo = create(:judge, id: 311, first: 'Ján', last: 'Gallo', name: 'JUDr. Ján Gallo')
      index_with_indicators(gallo)

      visit judge_path(gallo, anchor: 'indicators-2017')

      expect(find_by_id('indicators-2017')).to have_text(
        I18n.t('judges.indicators_2015.basic.dominant_decided_agenda') +
          I18n.t('judges.indicators_2015.basic.decided_agenda.Trest')
      )
    end
  end

  describe 'the indicators in the browser', :js do
    it 'draws the comparison chart and narrows the judges to compare as one types' do
      dalak = create(:judge, id: 194, first: 'Ivan', last: 'Ďalak', name: 'JUDr. Ivan Ďalak')
      zilkova = create(:judge, id: 1492, first: 'Margita', last: 'Žilková', name: 'JUDr. Margita Žilková')
      kvetkova = create(:judge, id: 699, first: 'Viera', last: 'Kvetková', name: 'JUDr. Viera Kvetková')
      [dalak, zilkova, kvetkova].each { |judge| create(:employment, court:, judge:) }
      index_with_indicators(dalak, zilkova, kvetkova)

      visit judge_path(dalak, anchor: 'indicators-2017')

      expect(page).to have_css('#indicators-2017.active canvas[data-indicators-chart-drawn]')

      additional = facet(I18n.t('judges.indicators_2013.numerical.additional_judges'))
      within(additional) { fill_in 'name', with: 'zilk' }

      expect(additional).to have_css('.facet-item', text: 'JUDr. Margita Žilková')
      expect(additional).to have_no_css('.facet-item', text: 'JUDr. Viera Kvetková')
    end
  end
end
