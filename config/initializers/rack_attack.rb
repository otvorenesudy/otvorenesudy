Rack::Attack.blacklist('Pentesters') do |req|
  Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes) do
    CGI.unescape(req.query_string) =~ %r{/etc/passwd} || req.path.include?('/etc/passwd') ||
      req.path.include?('wp-admin') || req.path.include?('wp-login')
  end
end

Rack::Attack.throttle('req/ip', limit: 10, period: 5.seconds, bantime: 24.hour) { |req| req.ip }

Rack::Attack.blacklist('Block bots accessing search') do |req|
  CrawlerDetect.is_crawler?(req.user_agent) &&
    req.path =~ %r{/(courts|judges|hearings|decrees|proceedings|selection_procedures)(\z|\?)}
end
