# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages' do
  let(:static_pages) { %w[about contact copyright faq feedback privacy tos] }

  it 'shows the home page with a carousel whose indicators match its slides' do
    visit root_path

    slides = all('#carousel .carousel-item').size

    expect(slides).to be_positive
    expect(page).to have_css('#carousel .carousel-indicators [data-bs-slide-to]', count: slides)
    expect(page).to have_link(I18n.t('layouts.header.courts'), href: courts_path(l: :sk))
    expect(page).to have_link(I18n.t('layouts.header.decrees_uoo'), href: uoo_decrees_path(l: :sk))
  end

  it 'links the footer version to its release' do
    visit root_path

    version = OpenCourts::VERSION::STRING

    expect(page).to have_link(version, href: "https://github.com/otvorenesudy/otvorenesudy/releases/tag/v#{version}")
  end

  it 'shows each static page in Slovak' do
    static_pages.each do |slug|
      visit static_page_path(slug)

      expect(page).to have_css('h1', text: I18n.t("static_pages.#{slug}", locale: :sk))
      expect(page).to have_css('html[lang="sk"]')
    end
  end

  it 'shows each static page in English with ?l=en' do
    static_pages.each do |slug|
      visit static_page_path(slug, l: :en)

      expect(page).to have_css('h1', text: I18n.t("static_pages.#{slug}", locale: :en))
      expect(page).to have_css('html[lang="en"]')
    end
  end

  it 'switches the language from the header' do
    visit static_page_path('about')
    click_on I18n.t('layouts.header.english', locale: :sk)

    expect(page).to have_css('h1', text: I18n.t('static_pages.about', locale: :en))
  end

  it 'shows the not found page for an unknown page', :error_pages do
    visit '/no-such-page'

    expect(page).to have_http_status(:not_found)
    expect(page).to have_css('h1', text: I18n.t('exceptions.not_found.title'))
  end

  it 'goes to the home page for an unsupported language' do
    visit static_page_path('about', l: :xx)

    expect(page).to have_current_path(root_path(l: :sk))
  end
end
