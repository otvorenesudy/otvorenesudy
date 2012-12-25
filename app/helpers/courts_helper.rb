# encoding: utf-8

module CourtsHelper
  def court_email(court, separator = ', ')
    court.email.split(/,\s+/).map { |email| mail_to email, nil, encode: :hex }.join(separator).html_safe
  end

  def court_phone(court, separator = ', ')
    court.phone.split(/,\s+/).join(separator).html_safe
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
    groups  = courts.is_a?(Hash) ? courts : courts_group_by_coordinates(courts)
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
      
      last_map: [:singleton, :last].include?(options[:maps]),
      
      markers: {
        data: courts_map_data(groups, options)
      }
    }
    
    data[:scripts] = :none if [:first, :middle].include?(options[:maps])
    
    map = gmaps(data)
    
    courts_map_scripts(id, options) if options[:info]
    
    map
  end
  
  def courts_group_by_coordinates(courts)
    groups = {}
    
    courts.each do |court|
      groups[court.coordinates] ||= []
      groups[court.coordinates] << court
    end

    groups
  end
  
  def link_to_court(court)
    link_to court.name, court_path(court.id)
  end
  
  private
  
  def courts_map_defaults
    {
      maps: :singleton,
      class: nil,
      info: false,
      zoom: 7,
      ui: true
    }
  end
  
  def courts_map_data(groups, options)
    groups.values.map { |group| group.first }.to_gmaps4rails do |court, marker|
      marker.infowindow render partial: 'map_marker_info.html', locals: { courts: groups[court.coordinates] }
    end
  end
  
  def courts_map_scripts(id, options)
    content_for :scripts do
      content_tag :script, type: :'text/javascript', charset: :'utf-8' do
        render partial: 'map_marker_info.js', locals: { id: id }
      end
    end
  end
end
