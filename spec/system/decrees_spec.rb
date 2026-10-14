# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Decrees' do
  let(:court) { create(:court, name: 'Okresný súd Košice I') }
  let(:judge) { create(:judge, first: 'Eva', last: 'Sudkyňa') }
  let(:area) { create(:legislation_area, value: 'Občianske právo') }
  let(:subarea) { create(:legislation_subarea, value: 'Nájom') }

  # Headings are uppercase on screen (CSS), so a browser reads them uppercase.
  def heading(text)
    /\A#{Regexp.escape(text)}\z/i
  end

  def facet(title)
    find('.facet-title', text: heading(title)).ancestor('.facet')
  end

  # A decree of the court by the judge, with its text, indexed with them (by a fresh instance: a decree keeps its
  # text once read).
  def decree(text: 'Okresný súd rozhodol v mene Slovenskej republiky.', **attributes, &)
    create(:decree, court:, **attributes).tap do |decree|
      create(:judgement, decree:, judge:)
      create(:decree_page, decree:, number: 1, text:)
      yield decree if block_given?
      Decree.find(decree.id).update_index
    end
  end

  describe 'the listing' do
    it 'lists decrees, latest first, with their court and judges' do
      decree(date: Date.new(2026, 3, 4), case_number: '1Co/1/2026')
      decree(date: Date.new(2026, 5, 6), case_number: '2Co/1/2026') do |item|
        item.legislation_subareas << subarea
        item.natures << create(:decree_nature, value: 'Konečné')
      end
      refresh_indices

      visit decrees_path

      latest = first('.search-result-item')

      expect(latest).to have_link(href: /#{decree_path(Decree.find_by!(case_number: '2Co/1/2026'))}/)
      expect(latest).to have_text('Rozsudok – Nájom')
      expect(latest).to have_text('Konečné')
      expect(latest).to have_link('Okresný súd Košice I')
      expect(latest).to have_link('JUDr. Eva Sudkyňa')
    end

    it 'finds decrees by their text, without diacritics, and highlights the words found' do
      decree(text: 'Žalobca sa domáhal zaplatenia nájomného.')
      decree(text: 'Obžalovaný sa dopustil krádeže.')
      refresh_indices

      visit decrees_path(q: 'najomneho')

      expect(page).to have_css('.search-result-item', count: 1)
      expect(page).to have_css('.search-result-highlights em', text: 'nájomného')
      expect(page).to have_link(href: /h=n%C3%A1jomn%C3%A9ho/)
    end

    it 'filters by legislation area, nature and month' do
      decree(case_number: '1Co/1/2026', date: Date.new(2026, 3, 4)) { |item| item.legislation_areas << area }
      decree(case_number: '2Co/1/2026', date: Date.new(2026, 5, 6))
      refresh_indices

      visit decrees_path
      within(facet('Právna oblasť')) { click_on 'Občianske právo' }

      expect(page).to have_css('.search-result-item', count: 1, text: '1Co/1/2026')

      visit decrees_path
      within(facet('Dátum')) { click_on 'Máj, 2026' }

      expect(page).to have_css('.search-result-item', count: 1, text: '2Co/1/2026')
    end
  end

  describe 'a decree' do
    it 'shows its court, judges, areas, form and numbers, linked to the decrees with them' do
      item = decree(case_number: '7Co/12/2026', summary: 'Žaloba bola zamietnutá.') do |record|
        record.legislation_areas << area
        record.legislation_subareas << subarea
        record.natures << create(:decree_nature, value: 'Konečné')
      end
      decree
      refresh_indices

      visit decree_path(item)

      expect(page).to have_css('h1', text: 'Rozsudok – Nájom')
      expect(page).to have_link('Okresný súd Košice I')
      expect(page).to have_link('JUDr. Eva Sudkyňa')
      expect(page).to have_text('Občianske právo – Nájom')
      expect(page).to have_text('Žaloba bola zamietnutá.')

      click_on 'Konečné'

      expect(page).to have_css('.search-result-item', count: 1)

      visit decree_path(item)
      click_on '7Co/12/2026'

      expect(page).to have_css('.search-result-item', count: 1, text: '7Co/12/2026')
    end

    it 'links its legislations to their texts' do
      item = decree do |record|
        record.legislations << create(:legislation, number: '40', year: 1964, paragraph: '663',
                                                    value: 'Občiansky zákonník')
        record.legislations << create(:legislation, number: nil, year: nil, value: 'Zákon o súdoch § 5')
      end

      visit decree_path(item)

      expect(page).to have_link(href: 'http://www.zakonypreludi.sk/zz/1964-40#p663')
      expect(page).to have_link(href: 'http://www.zakonypreludi.sk/main/search.aspx?text=Z%C3%A1kon+o+s%C3%BAdoch+%C2%A7+5')
    end

    it 'shows its text when it has no document' do
      item = decree(text: 'Okresný súd rozhodol takto.', pdf_uri: nil)

      visit decree_path(item)

      expect(page).to have_text('Okresný súd rozhodol takto.')
    end

    it 'lists decrees similar in meaning' do
      vector = Array.new(768) { |index| index.even? ? 1.0 : 0.0 }
      item = decree(embedding: vector)
      similar = decree(case_number: '9Co/9/2026', embedding: vector.map { |value| value + 0.01 })

      visit decree_path(item)

      expect(find_by_id('similar')).to have_link(href: /#{decree_path(similar)}/)
    end

    it 'warns about an incomplete decree and one from the future' do
      item = create(:decree, court: nil, date: 1.month.from_now.to_date)

      visit decree_path(item)

      expect(page).to have_css('.alert-danger', text: I18n.t('decrees.show.unprocessed'))
      expect(page).to have_css('.alert-danger', text: I18n.t('decrees.show.future_date'))
    end

    it 'shows the not found page for a decree that does not exist', :error_pages do
      visit decree_path(id: 0)

      expect(page).to have_http_status(:not_found)
    end
  end

  describe 'the decrees of a court and of a judge' do
    it 'lists the latest ones and links to all of them' do
      decree(case_number: '1Co/1/2026')
      refresh_indices

      visit court_path(court)

      expect(find_by_id('decrees')).to have_text('1Co/1/2026')

      within('#decrees') { click_on I18n.t('courts.decrees.more') }

      expect(page).to have_css('.search-result-item', count: 1, text: '1Co/1/2026')

      visit judge_path(judge)

      expect(find_by_id('decrees')).to have_text('1Co/1/2026')
    end
  end
end
