# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://otvorenesudy.sk'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  %i[en sk].each do |l|
    add "/?l=#{l}"

    add "/about?l=#{l}"
    add "/contact?l=#{l}"
    add "/copyright?l=#{l}"
    add "/faq?l=#{l}"
    add "/feedback?l=#{l}"
    add "/privacy?l=#{l}"
    add "/tos?l=#{l}"

    Court.pluck(:id).each do |id|
      add court_path(id, l: l), changefreq: 'daily', priority: 0.6
    end

    Judge.pluck(:id).each do |id|
      add judge_path(id, l: l), changefreq: 'daily', priority: 0.6
    end

    Hearing.pluck(:id).each do |id|
      add hearing_path(id, l: l), changefreq: 'daily', priority: 0.9
    end

    Decree.pluck(:id).each do |id|
      add decree_path(id, l: l), changefreq: 'daily', priority: 0.7
    end

    Proceeding.pluck(:id).each do |id|
      add proceeding_path(id, l: l), changefreq: 'daily', priority: 0.8
    end

    SelectionProcedure.pluck(:id).each do |id|
      add selection_path(id, l: l), changefreq: 'daily', priority: 0.6
    end
  end
end
