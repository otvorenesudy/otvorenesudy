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
    task :dump, [:limit, :batch_size] => :environment do |_, args|
      decrees   = Decree.order(:id, :updated_at).limit(args[:limit] || 100)
      directory = "api-decrees-#{Time.now.strftime('%Y%m%d%H%M')}"
      index     = 0

      FileUtils.mkdir_p(Rails.root.join('tmp', directory))

      decrees.find_in_batches(batch_size: args[:batch_size] ? args[:batch_size].to_i : 10000) do |batch|
        File.open(Rails.root.join('tmp', directory, "%03d.json" % index), 'w') do |f|
          f.write(ActiveModel::ArraySerializer.new(batch, each_serializer: DecreeSerializer, root: :decrees, scope: scope).to_json)
        end

        index += 1
      end
    end
  end
end
