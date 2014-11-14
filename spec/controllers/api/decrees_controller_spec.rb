require 'spec_helper'
require 'controllers/concerns/api/authorizable_spec'

describe API::DecreesController do
  it_behaves_like API::Authorizable
end
