require 'spec_helper'
require 'controllers/concerns/api/authorizable_spec'
require 'controllers/concerns/api/syncable_spec'

describe API::DecreesController do
  it_behaves_like API::Authorizable
  it_behaves_like API::Syncable do
    let(:repository) { Decree }
    let(:url)        { ->(*args) { sync_api_decrees_url(*args) } }
  end
end
