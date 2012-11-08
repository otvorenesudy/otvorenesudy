require 'agent_spec_helper'

describe Agent do

  before :each do
    remove_fixtures(AGENT_FIXTURES_PATH)
    @agent = Agent.new

    @agent.verbose = false
    @agent.cache_root = AGENT_FIXTURES_PATH
  end

  it "should download page" do
    request = JusticeGovSk::Requests::CourtListRequest.new

    @agent.cache_load = false
    @agent.cache_store = false

    @agent.download(request)

    File.exists?(@agent.uri_to_path(request.url)).should be_false
  end

  it "should download page and stores it in cache" do
    request = JusticeGovSk::Requests::CourtListRequest.new

    @agent.cache_load = false
    @agent.cache_store = true

    @agent.download(request)

    File.exists?(@agent.uri_to_path(request.url)).should be_true
  end

  it "should load page from cache" do
    request = JusticeGovSk::Requests::CourtListRequest.new
    @agent.cache_load = false
    @agent.cache_store = true
    @agent.download(request)
  
    File.exists?(@agent.uri_to_path(request.url)).should be_true
    
    @agent.cache_load = true
    @agent.download(request)
  end
end
