# TODO refactor resque task interface

# Examples:
# 
# rake run:crawlers:courts
# 
# rake run:crawlers:judges
# 
# rake run:crawlers:hearings:civil
# rake run:crawlers:hearings:criminal
# rake run:crawlers:hearings:special
# 
# rake run:crawlers:decrees[F]

namespace :run do
  # TODO refactor interface
  
  
  
  task :crawlers, [:type, :decree_form] => :environment do |_, args|
    JusticeGovSk.work args[:type], decree_form: args[:decree_form]
  end
end
