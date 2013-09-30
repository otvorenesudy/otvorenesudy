module SudnaradaGovSk
  class Configuration
    include Squire::Base

    squire.source    Rails.root.join('config', 'justice_gov_sk.yml')
    squire.namespace Rails.env, base: :defaults
  end
end
