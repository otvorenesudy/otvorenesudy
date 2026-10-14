# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Proceedings' do
  let(:court) { create(:court, name: 'Okresný súd Košice I', acronym: 'OSKE1') }
  let(:judge) { create(:judge, first: 'Eva', last: 'Sudkyňa') }

  # A proceeding with a hearing and, when it ended, a decree, indexed with them; a fresh instance, as the created one
  # read its (then empty) events when it indexed itself.
  def proceeding(case_number:, closed: true, text: 'Súd rozhodol o návrhu.')
    proceeding = create(:proceeding)
    hearing = create(:hearing, proceeding:, court:, case_number:, date: Time.zone.local(2026, 1, 12, 9))
    create(:judging, hearing:, judge:)

    if closed
      decree = create(:decree, proceeding:, court:, case_number:, date: Date.new(2026, 3, 4))
      create(:judgement, decree:, judge:)
      create(:decree_page, decree:, number: 1, text:)
    end

    Proceeding.find(proceeding.id).tap(&:update_index)
  end

  describe 'the listing' do
    it 'lists proceedings with their courts, judges and events' do
      proceeding(case_number: '1C/1/2026')
      refresh_indices

      visit proceedings_path

      item = find('.search-result-item')

      expect(item).to have_link('OSKE1 1C/1/2026')
      expect(item).to have_text('1 pojednávanie a 1 rozhodnutie')
      expect(item).to have_link('Okresný súd Košice I')
      expect(item).to have_link('JUDr. Eva Sudkyňa')
    end

    it 'finds proceedings by the text of their decrees and highlights the words found' do
      proceeding(case_number: '1C/1/2026', text: 'Žalobca sa domáhal zaplatenia nájomného.')
      proceeding(case_number: '2C/1/2026', text: 'Obžalovaný sa dopustil krádeže.')
      refresh_indices

      visit proceedings_path(q: 'najomneho')

      expect(page).to have_css('.search-result-item', count: 1, text: '1C/1/2026')
      expect(page).to have_css('.search-result-highlights em', text: 'nájomného')
    end

    it 'names an event at an unknown court by its case number alone' do
      proceeding = create(:proceeding)
      create(:hearing, proceeding:, court: nil, case_number: '3C/1/2026')
      Proceeding.find(proceeding.id).update_index
      refresh_indices

      visit proceedings_path

      expect(find('.search-result-item')).to have_link('3C/1/2026', exact: true)
    end

    it 'shows only the proceedings that ended when asked' do
      proceeding(case_number: '1C/1/2026')
      proceeding(case_number: '2C/1/2026', closed: false)
      refresh_indices

      visit proceedings_path

      expect(page).to have_css('.search-result-item', count: 2)

      click_on I18n.t('facets.proceeding.closed.value')

      expect(page).to have_css('.search-result-item', count: 1, text: '1C/1/2026')
    end
  end

  describe 'a proceeding' do
    it 'shows its courts, judges and events in time' do
      item = proceeding(case_number: '1C/1/2026')

      visit proceeding_path(item)

      expect(page).to have_css('h1', text: 'OSKE1 1C/1/2026')
      expect(page).to have_link('Okresný súd Košice I')
      expect(page).to have_link('JUDr. Eva Sudkyňa')

      events = all('.timeline-item a').pluck(:href)

      expect(events.first).to include(decree_path(item.decrees.first))
      expect(events.last).to include(hearing_path(item.hearings.first))
    end

    it 'shortens its subject where production does and shows the rest on the ellipsis' do
      item = proceeding(case_number: '1C/1/2026')
      item.decrees.sole.legislation_areas << create(:legislation_area, value: 'Občianske právo')
      item.decrees.sole.legislation_subareas << create(:legislation_subarea,
                                                       value: 'Zodpovednosť za škodu pri výkone verejnej moci')

      visit proceeding_path(item)

      expect(page).to have_css('h1', text: 'Občianske právo – Zodpovednosť za škodu pri…')
      expect(find('h1').all('a',
                            text: '…').last['data-bs-title']).to eq('Zodpovednosť za škodu pri výkone verejnej moci')
    end

    it 'spaces its events more than a year apart widest on the timeline' do
      item = proceeding(case_number: '1C/1/2026')
      item.hearings.sole.update!(date: Time.zone.local(2024, 1, 12, 9))

      visit proceeding_path(item)

      expect(page).to have_css('.timeline-item.timeline-distance-more-than-year', count: 1)
    end

    it 'names its judges as the sources wrote them when none matched exactly' do
      item = create(:proceeding)
      hearing = create(:hearing, proceeding: item, court:)
      create(:judging, hearing:, judge:, judge_name_similarity: 0.8, judge_name_unprocessed: 'JUDr. SUDKYŇA Eva, PhD.')
      decree = create(:decree, proceeding: item, court:)
      create(:judgement, decree:, judge_name_similarity: 0.6, judge_name_unprocessed: 'Mgr. Ján NOVÁK')
      Proceeding.find(item.id).update_index
      refresh_indices

      visit proceeding_path(item)

      expect(page).to have_text(/JUDr\. Eva Sudkyňa, PhD\.\s+a\s+Mgr\. Ján Novák/)
      expect(page).to have_no_link('JUDr. Eva Sudkyňa')

      visit proceedings_path

      expect(find('.search-result-item')).to have_text(/JUDr\. Eva Sudkyňa, PhD\.\s+a\s+Mgr\. Ján Novák/)
    end

    it 'links its case number to the proceedings with it' do
      item = proceeding(case_number: '1C/1/2026')
      proceeding(case_number: '2C/1/2026')
      refresh_indices

      visit proceeding_path(item)
      within('.bg-light') { click_on '1C/1/2026' }

      expect(page).to have_css('.search-result-item', count: 1, text: '1C/1/2026')
    end

    it 'is linked from its hearings and decrees' do
      item = proceeding(case_number: '1C/1/2026')

      visit hearing_path(item.hearings.first)
      click_on I18n.t('hearings.show.in_proceeding')

      expect(page).to have_css('h1', text: 'OSKE1 1C/1/2026')

      visit decree_path(item.decrees.first)
      click_on I18n.t('decrees.show.in_proceeding')

      expect(page).to have_css('h1', text: 'OSKE1 1C/1/2026')
    end

    it 'shows the not found page for a proceeding that does not exist', :error_pages do
      visit proceeding_path(id: 0)

      expect(page).to have_http_status(:not_found)
    end
  end
end
