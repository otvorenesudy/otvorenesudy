module Core
  class Configuration
    include Squire::Base

    squire.source    Rails.root.join('config', 'core.yml')
    squire.namespace Rails.env, base: :defaults
  end
end
