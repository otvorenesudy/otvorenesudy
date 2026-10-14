# frozen_string_literal: true

require 'rails_helper'

# The document of a decree, shown by pdf.js on the decree's page. The decree's source serves a two-page PDF
# (spec/fixtures/files/decree.pdf): "Najvyšší súd rozhodol v mene Slovenskej republiky." and "Proti rozsudku, ktorý
# potvrdil Najvyšší súd, nie je prípustné odvolanie."
RSpec.describe 'The document viewer of a decree', :js do
  let(:decree) { create(:decree, pdf_uri: 'https://obcan.justice.sk/decree/1.pdf') }

  before do
    pdf = file_fixture('decree.pdf').binread

    stub_request(:get, 'https://obcan.justice.sk/decree/1.pdf')
      .to_return(status: 200, body: pdf, headers: { 'Content-Type' => 'application/pdf' })
  end

  def page_number
    find('[data-pdf-viewer-target="pageNumber"]')
  end

  def match_count
    find('[data-pdf-viewer-target="matchCount"]')
  end

  def search_field
    find_field(I18n.t('shared.pdfjs.search'))
  end

  it 'shows the document page by page' do
    visit decree_path(decree)

    expect(page).to have_css('#pdf .page', count: 2)
    expect(page_number).to have_text('1 / 2')
    expect(page).to have_button(I18n.t('shared.pdfjs.previous_page'), disabled: true)

    click_on I18n.t('shared.pdfjs.next_page')

    expect(page_number).to have_text('2 / 2')
    expect(page).to have_button(I18n.t('shared.pdfjs.next_page'), disabled: true)

    click_on I18n.t('shared.pdfjs.previous_page')

    expect(page_number).to have_text('1 / 2')
  end

  it 'highlights the words the decrees were searched for' do
    create(:decree_page, decree:, number: 1, text: 'Najvyšší súd rozhodol v mene Slovenskej republiky.')
    Decree.find(decree.id).update_index
    refresh_indices

    visit decrees_path(q: 'rozhodol')
    find('.search-result-title a').click

    expect(page).to have_css('#pdf .textLayer .highlight', text: 'rozhodol', count: 1)
  end

  it 'finds words in the document regardless of diacritics and moves between them' do
    visit decree_path(decree)
    expect(page).to have_css('#pdf .page', count: 2)

    search_field.fill_in(with: 'najvyssi sud')

    expect(match_count).to have_text('1 / 2')
    expect(page).to have_text(I18n.t('shared.pdfjs.match_help'))

    click_on I18n.t('shared.pdfjs.next_match')

    expect(match_count).to have_text('2 / 2')
    expect(page_number).to have_text('2 / 2')

    search_field.send_keys(%i[shift enter])

    expect(match_count).to have_text('1 / 2')
    expect(page_number).to have_text('1 / 2')

    search_field.send_keys(:enter)

    expect(match_count).to have_text('2 / 2')

    click_on I18n.t('shared.pdfjs.previous_match')

    expect(match_count).to have_text('1 / 2')
  end

  it 'clears the search and highlights the searched words again' do
    visit decree_path(decree, h: 'rozhodol')
    expect(page).to have_css('#pdf .textLayer .highlight', text: 'rozhodol')

    search_field.fill_in(with: 'odvolanie')

    expect(match_count).to have_text('1 / 1')

    click_on I18n.t('shared.pdfjs.clear')

    expect(search_field.value).to be_empty
    expect(page).to have_no_css('[data-pdf-viewer-target="matchCount"]')
    expect(page).to have_css('#pdf .textLayer .highlight', text: 'rozhodol', count: 1)
  end

  it 'says when the document cannot be loaded' do
    stub_request(:get, 'https://obcan.justice.sk/decree/1.pdf').to_return(status: 404)

    visit decree_path(decree)

    expect(page).to have_text(I18n.t('shared.pdfjs.error'))
    expect(page).to have_no_css('#pdf .page')
  end
end
