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
    options = options.except(:class).reverse_merge(
      disableDefaultUI: false,
      fullscreenControl: true,
      zoom: 16
    )

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


  # TODO rm
  # def court_map(court, options = {})
  #   courts_map [court], options
  # end
  #
  # def court_map_direction(court, options = {})
  #   options = courts_map_defaults.merge options
  #   "https://maps.google.sk/maps?&t=m&z=#{options[:zoom]}&daddr=#{court.address '%s, %z %m, %c'}"
  # end
  #
  # def courts_map(courts, options = {})
  #   options = courts_map_defaults.merge options
  #   groups  = courts.is_a?(Hash) ? courts : Court::Map.build_groups(courts)
  #   id      = "map_#{groups.hash.abs}"
  #   data    = {
  #     map_options: {
  #       container_class: options[:class] ? [:map, options[:class]].join(' ') : :map,
  #       class: :view,
  #       id: id,
  #
  #       auto_adjust: true,
  #       auto_zoom: false,
  #       zoom: options[:zoom],
  #
  #       raw: "{ disableDefaultUI: #{!options[:ui]} }",
  #
  #       language: :sk,
  #       region: :sk,
  #       hl: :sk
  #     },
  #
  #     last_map: [:singleton, :last].include?(options[:map]),
  #
  #     markers: {
  #       data: courts_map_data(groups, options)
  #     }
  #   }
  #
  #   data[:scripts] = :none if [:first, :middle].include?(options[:map])
  #
  #   map = gmaps(data)
  #
  #   courts_map_scripts(id, options) if options[:info]
  #
  #   map
  # end
  # TODO rm
  # private
  #
  # def courts_map_defaults
  #   {
  #     map: :singleton,
  #     class: nil,
  #     info: false,
  #     zoom: 7,
  #     ui: true
  #   }
  # end
  #
  # def courts_map_data(groups, options)
  #   groups.values.map { |group| group.first }.to_gmaps4rails do |court, marker|
  #     marker.infowindow render 'courts/map_marker', courts: groups[court.coordinates]
  #   end
  # end
  #
  # def courts_map_scripts(id, options)
  #   content_for :scripts do
  #     content_tag :script, type: 'text/javascript', charset: 'utf-8' do
  #       render partial: 'courts/map_markers', formats: :js, locals: { id: id }
  #     end
  #   end
  # end

  def link_to_court(court, options = {})
    link_to court.name, court_path(court), options
  end

  def links_to_courts(courts, options = {})
    courts.map { |court| link_to_court(court, options) }.to_sentence.html_safe
  end

  def link_to_court_by_judge_employment(employment, options = {})
    options = judge_activity_options employment.judge, options.merge(adjust_by_activity_at: employment.court)

    link_to_court employment.court, options
  end
end
