# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Hearings' do
  subject { create(:hearing_subject, value: 'O zaplatenie') }

  let(:court) { create(:court, name: 'Okresný súd Košice I') }
  let(:judge) { create(:judge, first: 'Eva', last: 'Sudkyňa') }
  let(:form) { create(:hearing_form, value: 'Pojednávanie a rozhodnutie') }

  # Headings are uppercase on screen (CSS), so a browser reads them uppercase.
  def heading(text)
    /\A#{Regexp.escape(text)}\z/i
  end

  def facet(title)
    find('.facet-title', text: heading(title)).ancestor('.facet')
  end

  def result_titles
    all('.search-result-title > a:first-child').map(&:text)
  end

  # A hearing at the court before the judge, indexed with its judge and parties.
  def hearing(**attributes, &)
    create(:hearing, court:, form:, subject:, **attributes).tap do |hearing|
      create(:judging, hearing:, judge:)
      yield hearing if block_given?
      hearing.update_index
    end
  end

  describe 'the listing' do
    it 'lists hearings, latest first, with their court, judges and parties' do
      hearing(date: 2.months.from_now, case_number: '2C/1/2026') do |item|
        create(:proposer, hearing: item, name: 'J. N.')
      end
      hearing(date: 1.month.from_now, case_number: '1C/1/2026')
      refresh_indices

      visit hearings_path

      expect(result_titles).to eq(['Pojednávanie a rozhodnutie, O zaplatenie'] * 2)

      latest = first('.search-result-item')

      expect(latest).to have_text('2C/1/2026')
      expect(latest).to have_link('Okresný súd Košice I')
      expect(latest).to have_link('JUDr. Eva Sudkyňa')
      expect(latest).to have_text('Navrhovateľ – J. N.')
    end

    it 'finds a hearing by a party, without diacritics' do
      hearing { |item| create(:opponent, hearing: item, name: 'Ján Šťastný') }
      hearing { |item| create(:opponent, hearing: item, name: 'Peter Smutný') }
      refresh_indices

      visit hearings_path(q: 'stastny')

      expect(page).to have_css('.search-result-item', count: 1, text: 'Ján Šťastný')
    end

    it 'hides past hearings when asked' do
      hearing(date: 1.month.ago, case_number: '1C/1/2020')
      hearing(date: 1.month.from_now, case_number: '2C/1/2026')
      refresh_indices

      visit hearings_path

      expect(page).to have_css('.search-result-item', count: 2)

      click_on I18n.t('facets.hearing.historical.value')

      expect(page).to have_css('.search-result-item', count: 1, text: '2C/1/2026')
    end

    it 'filters by court and offers hearings without a court as missing' do
      hearing(case_number: '1C/1/2026')
      hearing(case_number: '2C/1/2026', court: nil)
      refresh_indices

      visit hearings_path
      within(facet('Súd')) { click_on 'Neuvedený' }

      expect(page).to have_css('.search-result-item', count: 1, text: '2C/1/2026')

      visit hearings_path
      within(facet('Súd')) { click_on 'Okresný súd Košice I' }

      expect(page).to have_css('.search-result-item', count: 1, text: '1C/1/2026')
    end

    it 'shortens a long title' do
      hearing(form: create(:hearing_form,
                           value: 'Pojednávanie a rozhodnutie o návrhu na nariadenie predbežného opatrenia'))
      refresh_indices

      visit hearings_path

      expect(result_titles).to eq(['Pojednávanie a rozhodnutie o návrhu na nariadenie…'])
    end

    it 'offers the proposers only for civil hearings' do
      hearing { |item| create(:proposer, hearing: item, name: 'J. N.') }
      refresh_indices

      visit hearings_path

      expect(page).to have_css('.facet-title', text: heading('Navrhovatelia'))

      visit hearings_path(type: ['Trestné'])

      expect(page).to have_css('.facet-item.active', text: 'Trestné')
      expect(page).to have_no_css('.facet-title', text: heading('Navrhovatelia'))
    end
  end

  describe 'a hearing' do
    it 'shows its court, judges, parties and accusations' do
      chair = create(:judge, first: 'Ján', last: 'Predseda')
      item = hearing(room: '12', type: HearingType.criminal) do |record|
        create(:judging, hearing: record, judge: chair, judge_chair: true)
        defendant = create(:defendant, hearing: record, name: 'P. S.')
        accusation = Accusation.create!(defendant:, value: 'Krádež', value_unprocessed: 'Krádež')
        paragraph = Paragraph.create!(legislation: 300, number: '212', description: '§ 212 Trestného zákona')
        ParagraphExplanation.create!(paragraph:, explainable: accusation)
      end

      visit hearing_path(item)

      expect(page).to have_css('h1', text: 'Pojednávanie a rozhodnutie, O zaplatenie')
      expect(page).to have_text('na súde Okresný súd Košice I, v miestnosti 12.')
      expect(page).to have_text("#{I18n.t('hearings.show.chairman')} JUDr. Ján Predseda.")
      expect(page).to have_link('JUDr. Eva Sudkyňa')
      expect(page).to have_text('P. S.')
      expect(page).to have_text('§ 212 Trestného zákona, Krádež')
    end

    it 'shortens a long title and shows it in full on hover' do
      form = create(:hearing_form, value: 'Pojednávanie a rozhodnutie o návrhu na nariadenie predbežného opatrenia')
      item = hearing(form:)

      visit hearing_path(item)

      expect(page).to have_css('h1', text: 'Pojednávanie a rozhodnutie o návrhu na nariadenie…')
      expect(find('h1').find_link('…')['data-bs-title']).to eq("#{form.value}, O zaplatenie")
    end

    it 'describes a hearing of the specialized criminal court' do
      item = hearing(type: HearingType.special)

      visit hearing_path(item)

      type = 'Pojednávanie špecializovaného trestného súdu'

      expect(page).to have_title(/#{type}/)
      expect(page).to have_text("#{type} sa bude konať na súde Okresný súd Košice I")
    end

    it 'links its subject and numbers to the hearings with them' do
      item = hearing(case_number: '7Co/12/2026')
      hearing(subject: create(:hearing_subject, value: 'O výživné'))
      refresh_indices

      visit hearing_path(item)
      click_on 'O zaplatenie'

      expect(page).to have_css('.search-result-item', count: 1)

      visit hearing_path(item)
      click_on '7Co/12/2026'

      expect(page).to have_css('.search-result-item', count: 1, text: '7Co/12/2026')
    end

    it 'links its original court and its proceeding' do
      original = create(:court, name: 'Okresný súd Michalovce')
      proceeding = create(:proceeding)
      item = hearing(original_court: original, proceeding:)

      visit hearing_path(item)

      expect(page).to have_link('Okresný súd Michalovce')
      expect(page).to have_link(I18n.t('hearings.show.in_proceeding'), href: proceeding_path(proceeding, l: :sk))
    end

    it 'warns about an incomplete hearing, a distant date and an anonymized one' do
      item = create(:hearing, court: nil, date: 3.years.from_now, anonymized_at: Time.current)

      visit hearing_path(item)

      expect(page).to have_css('.alert-danger', text: I18n.t('hearings.show.unprocessed'))
      expect(page).to have_css('.alert-danger', text: I18n.t('hearings.show.future_date'))
      expect(page).to have_css('.alert', text: I18n.t('hearings.show.anonymized'))
    end

    it 'shows the not found page for a hearing that does not exist', :error_pages do
      visit hearing_path(id: 0)

      expect(page).to have_http_status(:not_found)
    end

    it 'lets an admin anonymize its parties' do
      item = hearing(anonymized_at: nil) { |record| create(:opponent, hearing: record, name: 'Ján Šťastný') }
      login_as create(:user, :admin)

      visit hearing_path(item)
      click_on I18n.t('hearings.show.anonymize')

      expect(page).to have_text(I18n.t('hearings.anonymize.success'))
      expect(page).to have_css('.alert', text: I18n.t('hearings.show.anonymized'))
      expect(page).to have_no_text('Ján Šťastný')
      expect(page).to have_no_button(I18n.t('hearings.show.anonymize'))
    end

    it 'offers no anonymization to a visitor' do
      item = hearing(anonymized_at: nil)

      visit hearing_path(item)

      expect(page).to have_css('h1', text: 'Pojednávanie a rozhodnutie, O zaplatenie')
      expect(page).to have_no_button(I18n.t('hearings.show.anonymize'))
    end
  end

  describe 'the hearings of a court and of a judge' do
    it 'lists the latest ones and links to all of them' do
      hearing(case_number: '1C/1/2026')
      hearing(case_number: '2C/1/2020', date: 1.month.ago)
      refresh_indices

      visit court_path(court)

      expect(find_by_id('hearings')).to have_text('1C/1/2026')

      within('#hearings') { click_on I18n.t('courts.hearings.more') }

      expect(page).to have_css('.search-result-item', count: 2)

      visit judge_path(judge)

      expect(find_by_id('upcoming-hearings')).to have_text('1C/1/2026')
      expect(find_by_id('historical-hearings')).to have_text('2C/1/2020')
    end
  end
end
