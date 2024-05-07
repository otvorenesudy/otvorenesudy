if Rails.env.production? || Rails.env.staging?
  Rack::Attack.blacklist('Pentesters') do |req|
    Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes) do
      CGI.unescape(req.query_string) =~ %r{/etc/passwd} || req.path.include?('/etc/passwd') ||
        req.path.include?('wp-admin') || req.path.include?('wp-login')
    end
  end

  Rack::Attack.throttle('req/ip', limit: 10, period: 5.seconds) { |req| req.ip unless req.path.match(%r{\A/sidekiq}) }

  Rack::Attack.blacklist('Block IP') do |req|
    Rack::Attack::Allow2Ban.filter("throttle-ban-#{req.ip}", maxretry: 10, findtime: 5.seconds, bantime: 1.hours) do
      !req.path.match(%r{\A/sidekiq})
    end
  end

  Rack::Attack.blacklist('Block bots accessing search') do |req|
    CrawlerDetect.is_crawler?(req.user_agent) &&
      req.path =~ %r{/(courts|judges|hearings|decrees|proceedings|selection_procedures)(\z|\?)}
  end

  Rack::Attack.blacklisted_responder = lambda { |request| [503, {}, ['Blocked']] }
  Rack::Attack.throttled_responder = lambda { |request| [503, {}, ["Server Error\n"]] }
end
