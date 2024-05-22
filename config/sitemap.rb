# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://otvorenesudy.sk'

SitemapGenerator::Sitemap.create do
  %i[en sk].each do |l|
    add "/?l=#{l}"

    add "/about?l=#{l}"
    add "/contact?l=#{l}"
    add "/copyright?l=#{l}"
    add "/faq?l=#{l}"
    add "/feedback?l=#{l}"
    add "/privacy?l=#{l}"
    add "/tos?l=#{l}"

    Court.pluck(:id).each { |id| add court_path(id, l: l), changefreq: 'daily', priority: 0.6 }

    Judge.pluck(:id).each { |id| add judge_path(id, l: l), changefreq: 'daily', priority: 0.6 }

    Hearing.pluck(:id).each { |id| add hearing_path(id, l: l), changefreq: 'hourly', priority: 1 }

    Decree.pluck(:id).each { |id| add decree_path(id, l: l), changefreq: 'hourly', priority: 1 }

    Proceeding.pluck(:id).each { |id| add proceeding_path(id, l: l), changefreq: 'daily', priority: 0.8 }

    SelectionProcedure.pluck(:id).each { |id| add selection_path(id, l: l), changefreq: 'daily', priority: 0.6 }
  end
end
