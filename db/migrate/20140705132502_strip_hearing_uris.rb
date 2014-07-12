class StripHearingUris < ActiveRecord::Migration
  def up
    models = [Judge, Hearing]

    models.each do |model|
      model.where("uri LIKE '% %'").find_each do |record|
        record.uri_will_change!
        record.uri.strip!

        # TODO resolve non-unique urls after strip
        record.save! rescue nil
      end
    end

    def down
    end
  end
end
