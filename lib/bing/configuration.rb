module Bing
  class Configuration < Settingslogic
    source File.join(Rails.root, 'config', 'bing.yml')

    namespace Rails.env
  end
end
