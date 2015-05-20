module Api
  module Syncable
    extend ActiveSupport::Concern

    def sync
      @records = syncable_repository.order(:updated_at, :id).limit(100)

      if params[:since]
        @records = @records.where('(updated_at, id) > (?, ?)', Time.parse(params[:since]), params[:last_id] || 0)
      end

      if @records.length == 100
        next_url = next_sync_url(since: @records.last.updated_at.as_json, last_id: @records.last.id, api_key: params[:api_key])
        headers['Link'] = "<#{next_url}>; rel='next'"
      end

      respond_with @records
    end
  end
end
