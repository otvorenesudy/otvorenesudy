scope = Class.new do
  class UrlHelper
    include Rails.application.routes.url_helpers
  end

  def self.method_missing(name, *args, &block)
    helper  = UrlHelper.new
    options = args.last.is_a?(Hash) ? args.delete(args.last) : {}

    options[:host] = 'otvorenesudy.sk'

    args << options

    helper.send(name, *args, &block)
  end
end

namespace :api do
  namespace :decrees do
    desc 'Dump API Decrees'
    task :dump, [:limit] => :environment do |_, args|
      decrees  = Decree.order(:id, :updated_at).limit(args[:limit] || 100)
      filename = "api-decrees-#{Time.now.strftime('%Y%m%d%H%M')}.json"

      File.open(Rails.root.join('tmp', filename), 'w') do |f|
        f.write(ActiveModel::ArraySerializer.new(decrees, each_serializer: DecreeSerializer, root: :decrees, scope: scope).to_json)
      end
    end
  end
end
