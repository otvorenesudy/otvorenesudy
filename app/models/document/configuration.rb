module Document
  class Configuration < Settingslogic
    source File.join(Rails.root, 'config', 'elasticsearch.yml')

    namespace Rails.env

    def self.models
      @models ||= indices.map { |e| e.singularize.to_sym }
    end
  end
end
