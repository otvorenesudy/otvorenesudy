module CourtsHelper
  def court_email(court, separator = ', ')
    court.email.split(/,\s+/).map { |email| mail_to email, nil, encode: :hex }.join(separator).html_safe
  end

  # TODO implement
  def court_phone(court, separator = ', ')
    court.phone
  end
  
  def court_map(court, options = {})
    courts_map [court], options
  end
  
  def courts_map(courts, options = {})
    options = courts_map_defaults.merge options
    id      = "map_#{'court'.pluralize(courts.count)}"
    data    = {
      map_options: {
        container_class: :map,
        class:           :view,
        id:              id,
        
        auto_adjust: true,
        auto_zoom:   false,
        zoom:        options[:zoom],
        
        raw: "{ disableDefaultUI: #{!options[:ui]} }",
        
        language: :sk,
        hl:       :sk,
        region:   :sk
      },
      
      markers: {
        data: courts_map_markers(courts, options)
      }
    }
    
    html = gmaps data
    
    if options[:info]
      content_for :scripts do
        content_tag :script, type: 'text/javascript', charset: 'utf-8' do
          #render(partial: 'map_marker_info.js', locals: { id: id })
        end
      end
    end
    
    html
  end

# TODO impl
#  def courts_map
#    Court.all.to_gmaps4rails do |court, marker|
#      marker.infowindow render('map_info', court: @court)
#      marker.json id: @court.id
#    end
#  end
  
  def link_to_court(court)
    link_to court.name, court_path(court.id)
  end
  
  private
  
  def courts_map_defaults
    {
      info: true,
      zoom: 16,
      ui:   true
    }
  end
  
  def courts_map_markers(courts, options)
    courts.to_gmaps4rails do |court, marker|
      marker.infowindow render(partial: 'map_marker_info.html', locals: { court: court }) if options[:info]
      marker.json id: court.id
    end
  end
end
