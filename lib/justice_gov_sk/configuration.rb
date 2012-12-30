module JusticeGovSk
  class Configuration < Settingslogic
    source "#{Rails.root}/config/justice_gov_sk.yml"
    
    namespace Rails.env
    
    load!
  end  
end
