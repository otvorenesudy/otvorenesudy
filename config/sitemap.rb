# frozen_string_literal: true

# The sitemap of every page, court, judge, hearing, decree and proceeding in both languages (sitemap:refresh:no_ping,
# daily). Judge selection procedures are hidden, so left out.
SitemapGenerator::Sitemap.default_host = 'https://otvorenesudy.sk'

SitemapGenerator::Sitemap.create do
  records = {
    Court => { priority: 0.6, changefreq: 'daily' },
    Judge => { priority: 0.6, changefreq: 'daily' },
    Hearing => { priority: 1, changefreq: 'hourly' },
    Decree => { priority: 1, changefreq: 'hourly' },
    Proceeding => { priority: 0.8, changefreq: 'daily' }
  }

  %i[en sk].each do |l|
    add "/?l=#{l}"

    StaticPagesController::PAGES.each { |page| add "/#{page}?l=#{l}" }

    add uoo_decrees_path(l:)

    records.each do |model, options|
      route = "#{model.model_name.singular_route_key}_path"

      model.in_batches(of: 10_000) { |batch| batch.ids.each { |id| add public_send(route, id, l:), **options } }
    end
  end
end
