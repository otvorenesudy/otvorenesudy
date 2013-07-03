class Configuration < Settingslogic
  source File.join(Rails.root, 'config', 'configuration.yml')

  namespace Rails.env
end
