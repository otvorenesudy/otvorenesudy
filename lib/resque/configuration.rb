class Resque::Configuration < Settingslogic
  source File.join(Rails.root, 'config', 'resque.yml')

  namespace Rails.env
end
