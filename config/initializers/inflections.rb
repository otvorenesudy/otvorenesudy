# Be sure to restart your server when you modify this file.

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'súd', 'súdy'
  inflect.irregular 'sudca', 'sudcovia'
  inflect.irregular 'pojednávanie', 'pojednávania'
  inflect.irregular 'rozhodnutie', 'rozhodnutia'
  inflect.irregular 'konanie', 'konania'
end

# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
#   inflect.acronym 'RESTful'
# end
