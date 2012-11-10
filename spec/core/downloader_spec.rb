# encoding: utf-8

require 'downloader_spec_helper'

describe Downloader do 
  before :each do 
    @downloader = Downloader.new
    @downloader.wait_time = 0
    @downloader.cache_store = true
    @downloader.cache_load = false
    # cache root
    #@downloader.cache_root = DOWNLOADER_FIXTURE_PATH
  end

  after :each do
    @downloader.headers = @request.headers
    @downloader.data = @request.data

    html = @downloader.download(@request.url)

    html.should_not be_nil
  end

  describe "for Hearings List downloads" do
    it "should download second page of criminal hearings" do
      @request = JusticeGovSk::Requests::CriminalHearingListRequest.new 

      @request.page = 2
    end

    it 'should download third page of civil hearing ' do
      @request = JusticeGovSk::Requests::CivilHearingListRequest.new 

      @request.page = 3
    end

    it 'should download second page of special criminal hearings' do
      @request = JusticeGovSk::Requests::SpecialHearingListRequest.new

      @request.page = 1 
    end
  end

  describe "for Decrees List downloads" do
    it 'should download second page of Decrees' do
      @request = JusticeGovSk::Requests::DecreeListRequest.new

      @request.page = 2
    end
  end

  describe "for Judges List downloads" do
    it 'should download second page of judges' do
      @request = JusticeGovSk::Requests::JudgeListRequest.new

      @request.page = 2
    end
  end

  describe "for Courts List downloads" do 
    it 'should download second page of courts' do
      @request = JusticeGovSk::Requests::CourtListRequest.new

      @request.page = 2
    end
  end
end

