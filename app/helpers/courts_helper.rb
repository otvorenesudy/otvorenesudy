module CourtsHelper
  def court_email(court, separator = ', ')
    court.email.split(/,\s+/).map { |email| mail_to(email, nil, encode: :hex).ascii }.join(separator).html_safe
  end

  def court_phone(court, separator = ', ')
    court.phone.split(/,\s+/).map { |phone| phone.gsub(/\d\s+\d/) { |s| s[0] + '&nbsp;' + s[2] }}.join(separator).html_safe
  end
  
  def court_map(court, options = {})
    courts_map [court], options
  end
  
  def court_map_direction(court, options = {})
    options = courts_map_defaults.merge options
    "https://maps.google.sk/maps?&t=m&z=#{options[:zoom]}&daddr=#{court.address '%s, %z %m, %c'}"
  end
  
  def courts_map(courts, options = {})
    options = courts_map_defaults.merge options
    groups  = courts.is_a?(Hash) ? courts : Court::Map.build_groups(courts)
    id      = "map_#{groups.hash.abs}"
    data    = {
      map_options: {
        container_class: options[:class] ? [:map, options[:class]].join(' ') : :map,
        class: :view,
        id: id,
        
        auto_adjust: true,
        auto_zoom: false,
        zoom: options[:zoom],
        
        raw: "{ disableDefaultUI: #{!options[:ui]} }",
        
        language: :sk,
        region: :sk,
        hl: :sk
      },
      
      last_map: [:singleton, :last].include?(options[:map]),
      
      markers: {
        data: courts_map_data(groups, options)
      }
    }
    
    data[:scripts] = :none if [:first, :middle].include?(options[:map])
    
    map = gmaps(data)
    
    courts_map_scripts(id, options) if options[:info]
    
    map
  end
  
  def link_to_court(court, options = {})
    link_to court.name, court_path(court), options
  end

  def links_to_courts(courts, options = {})
    courts.map { |court| link_to_court(court, options) }.to_sentence.html_safe
  end
  
  def link_to_court_by_judge_employment(employment, options = {})
    options = judge_options employment.judge, options.merge(adjust_by_activity_at: employment.court)
    
    link_to_court employment.court, options
  end
  
  private
  
  def courts_map_defaults
    {
      map: :singleton,
      class: nil,
      info: false,
      zoom: 7,
      ui: true
    }
  end
  
  def courts_map_data(groups, options)
    groups.values.map { |group| group.first }.to_gmaps4rails do |court, marker|
      marker.infowindow render 'courts/map_marker_info.html', courts: groups[court.coordinates]
    end
  end
  
  def courts_map_scripts(id, options)
    content_for :scripts do
      content_tag :script, type: :'text/javascript', charset: :'utf-8' do
        render 'courts/map_marker_info.js', id: id
      end
    end
  end
end
