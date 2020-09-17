Rack::Attack.blacklist('Pentesters') do |req|
  Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes) do
    CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
    req.path.include?('/etc/passwd') ||
    req.path.include?('wp-admin') ||
    req.path.include?('wp-login')
  end
end

Rack::Attack.throttle('Bots', limit: 1, period: 60) do |req|
  req.user_agent =~ /(ggoglebot|bingbot|semrushbot|yandexbot|petalbot)/i
end
