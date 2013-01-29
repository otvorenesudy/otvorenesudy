# encoding: utf-8
require 'agent_spec_helper'

describe JusticeGovSk::Agent::List do

  after :each do
    @agent.repeat    = 1
    @agent.wait_time = 0
    
    page = @agent.download(@request)

    page.should_not be_nil
    page.content.should_not be_nil
    page.content.should_not be_empty
  end

  context "for Hearing List request" do
    before :each do
      @agent = JusticeGovSk::Agent::HearingList.new
    end

    it "should download 200th page of Criminal Hearings with 100 results including old records" do
      @request = JusticeGovSk::Request::CriminalHearingList.new

      @request.page = 200 
      @request.per_page = 100 
      @request.include_old_hearings = true
    end

    it "should download 300th page of Civil Hearings with 100 results inluding old records" do
      @request = JusticeGovSk::Request::CivilHearingList.new

      @request.page = 300 
      @request.per_page = 100 
      @request.include_old_hearings = true
    end

    it "should download 4th page of Special Hearings with 20 results including old records" do
      @request = JusticeGovSk::Request::SpecialHearingList.new

      @request.page = 4 
      @request.per_page = 20 
      @request.include_old_hearings = true
    end
  end

  context "for Judge List request" do
    before :each do
      @agent = JusticeGovSk::Agent::List.new
    end

    it "should download 25th page with 50 results" do
      @request = JusticeGovSk::Request::JudgeList.new

      @request.page = 4 
      @request.per_page = 20 
    end
  end

  context "for Court List request" do
    before :each do
      @agent = JusticeGovSk::Agent::List.new
    end

    it "should download first page with 100 results" do
      @request = JusticeGovSk::Request::CourtList.new

      @request.page = 1 
      @request.per_page = 100
    end
  end

  context "for Decree List request" do
    before :each do
      @agent = JusticeGovSk::Agent::DecreeList.new
    end
    
    it "should download 15th page with 100 results with form value 'R'" do 
      @request = JusticeGovSk::Request::DecreeList.new

      @request.page = 15
      @request.per_page = 100 
      @request.decree_form_code = 'R'
    end

    it "should fail when downloading 20th page with 100 results for form 'B'" do
      @request = JusticeGovSk::Request::DecreeList.new

      @request.page = 20
      @request.per_page = 100 
      @request.decree_form_code = 'B'
    end
  end 
end
