module CourtsHelper
  def court_email(court, separator = ', ')
    court.email.split(/,\s+/).map { |email| mail_to(email, nil, encode: :hex).ascii }.join(separator).html_safe
  end

  def court_phone(court, separator = ', ')
    court.phone.split(/,\s+/).map { |phone| phone.gsub(/\d\s+\d/) { |s| s[0] + '&nbsp;' + s[2] }}.join(separator).html_safe
  end

  def courts_map(courts, options = {})
    key = 'AIzaSyAOxHiahbFCA001J7SFq1C-U6qYUfaKvT8'

    courts = Array.wrap courts
    id = "map-#{courts.hash.abs}"

    groups = courts.group_by(&:coordinates)
    markers = Gmaps4rails.build_markers groups.keys do |coordinates, marker|
      marker.lat coordinates[:latitude]
      marker.lng coordinates[:longitude]
      marker.infowindow render(partial: 'courts/map/marker', locals: coordinates.merge(courts: groups[coordinates].sort_by(&:name))).html_safe
    end

    classes = Array.wrap(options[:class]) << 'map'
    options = options.except(:class).reverse_merge(disableDefaultUI: false, zoom: 16)

    content_for :scripts do
      content_tag :script, nil, type: 'text/javascript', src: "https://maps.google.com/maps/api/js?v=3.24&key=#{key}"
    end

    content_for :scripts do
      content_tag :script, type: 'text/javascript' do
        render(partial: 'courts/map/handler', formats: :js, locals: { id: id, options: options, markers: markers }).html_safe
      end
    end

    content_tag :div, nil, id: id, class: classes
  end

  def link_to_court(court, options = {})
    link_to court.name, court_path(court), options
  end

  def links_to_courts(courts, options = {})
    courts.map { |court| link_to_court(court, options) }.to_sentence.html_safe
  end

  def link_to_court_by_judge_employment(employment, options = {})
    link_to_court employment.court, judge_activity_options(employment.judge, options)
  end

  def link_to_institution(institution, options = {})
    court = Court.where(name: institution).first
    court ? link_to_court(court, options) : institution
  end
end
