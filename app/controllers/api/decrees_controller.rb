class Api::DecreesController < API::ApplicationController
  include Api::Syncable

  def syncable_repository
    Decree
  end

  def next_sync_url(*args)
    sync_api_decrees_url(*args)
  end
end
