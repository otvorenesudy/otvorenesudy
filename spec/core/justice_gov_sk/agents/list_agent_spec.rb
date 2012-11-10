require 'agent_spec_helper'

describe JusticeGovSk::Agents::ListAgent do
  before :each do
    @agent = JusticeGovSk::Agents::ListAgent.new

    @agent.cache_store = true
    @agent.cache_load = false
    @agent.verbose = true
    @agent.wait_time = 0
  end

  after :each do
    page = @agent.download(@request)

    page.should_not be_nil
    page.content.should_not be_nil
    page.content.should_not be_empty
  end

  describe "for Hearing List request" do
    it "should download 200th page of Criminal Hearings with 100 results including old records" do
      @request = JusticeGovSk::AgentRequests::CriminalHearingListRequest.new

      @request.page = 200 
      @request.per_page = 100 
      @request.hearing_or_decree_include_old = true
   end

    it "should download 400th page of Civil Hearings with 100 results inluding old records" do
      @request = JusticeGovSk::AgentRequests::CivilHearingListRequest.new

      @request.page = 400 
      @request.per_page = 100 
      @request.hearing_or_decree_include_old = true
    end

    it "should download 4th page of Special Hearings with 20 results including old records" do
      @request = JusticeGovSk::AgentRequests::SpecialHearingListRequest.new

      @request.page = 4 
      @request.per_page = 20 
      @request.hearing_or_decree_include_old = true
    end
  end

  describe "for Judge List request" do
    it "should download 25th page with 50 results" do
      @request = JusticeGovSk::AgentRequests::JudgeListRequest.new

      @request.page = 4 
      @request.per_page = 20 
    end
  end

  describe "for Court List request" do
    it "should download first page with 100 results" do
      @request = JusticeGovSk::AgentRequests::CourtListRequest.new

      @request.page = 1 
      @request.per_page = 100
    end
  end

  describe "for Decree List request" do
    it "should download 3500th page with 100 results including old records" do
      @request = JusticeGovSk::AgentRequests::DecreeListRequest.new

      @request.page = 3500 
      @request.per_page = 100 
    end

    it "should download 20th page with 100 results with form value 'R'" do 
      @request = JusticeGovSk::AgentRequests::DecreeListRequest.new

      @request.page = 15 
      @request.per_page = 100 
      @request.decree_form = 'R'
    end
  end 
end
