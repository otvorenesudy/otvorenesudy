Rack::Attack.blacklist('Pentesters') do |req|
  Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes) do
    CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
    req.path.include?('/etc/passwd') ||
    req.path.include?('wp-admin') ||
    req.path.include?('wp-login')
  end
end

Rack::Attack.throttle('req/ip', limit: 10, period: 5.seconds, bantime: 24.hour) do |req|
  req.ip
end

Rack::Attack.blacklist('Block bots accessing search') do |req|
   req.user_agent =~ /(googlebot|bingbot|semrushbot|yandexbot|petalbot|seokicks|dotbot|ahrefsbot|thesis-research-bot|gptbot|amazonbot)/i && req.path =~ /\/(courts|judges|hearings|decrees|proceedings|selection_procedures)(\z|\?)/
 end
