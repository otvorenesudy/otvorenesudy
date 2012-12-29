module Core
  class Configuration < Settingslogic
    source "#{Rails.root}/config/core.yml"
    
    namespace Rails.env
    
    load!
  end  
end
