# frozen_string_literal: true

Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect('uri' => 'URI')
end

# Commented out since the Bing API it used was shut down; it defines nothing to load.
Rails.autoloaders.main.ignore(Rails.root.join('app/models/resource/context_search.rb'))
