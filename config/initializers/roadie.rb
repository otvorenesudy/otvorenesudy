OpenCourts::Application.config.roadie.after_inlining = lambda do |document|
  options  = ActionMailer::Base.default_url_options
  hostname = "#{options[:host]}#{":#{options[:port]}" if options[:port]}"

  document.css('a').each do |link|
    unless link['href'].match(/(http:\/\/\w+[\.\:]|#)/)
      link['href'] = "http://#{hostname}#{link['href']}"
    end
  end
end
