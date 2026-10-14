# frozen_string_literal: true

require 'rails_helper'

# The decisions of the Whistleblower Protection Office (Úrad na ochranu oznamovateľov), from data/uoo-decrees.json.
RSpec.describe 'The decisions of the Whistleblower Protection Office' do
  let(:decisions) { Uoo::Data.all }
  let(:stats) { Uoo::Data.stats }

  it 'lists the decisions with the fines per party' do
    party = stats[:by_party].first

    visit uoo_decrees_path

    expect(page).to have_css('h1', text: I18n.t('decrees.uoo.title'))
    expect(page).to have_css('.lead', text: stats[:total_count].to_s)
    expect(find('table')).to have_css('tr', text: party[:name])
    expect(page).to have_css('.search-result-item', count: decisions.sum { |decision| 1 + decision['children'].size })
    expect(page).to have_link(href: decisions.first['url'])
  end

  it 'nests the appeals under the decision they decided, with their effect' do
    decision = decisions.find { |entry| entry['children'].any? { |child| child['effect_on_chain_root_decree'] } }
    appeal = decision['children'].find { |child| child['effect_on_chain_root_decree'] }

    visit uoo_decrees_path

    item = find('.search-result-list > .search-result-item', text: decision['title'])

    expect(item).to have_css('.search-result-list .search-result-item', text: appeal['title'])
    expect(item).to have_css('.badge', text: I18n.t("decrees.uoo.effect.#{appeal['effect_on_chain_root_decree']}"))
  end

  it 'searches the court decrees for a party' do
    party = stats[:by_party].first

    visit uoo_decrees_path
    within('table') { click_on party[:name] }

    expect(page).to have_current_path(decrees_path(q: party[:name], l: :sk))
  end
end
