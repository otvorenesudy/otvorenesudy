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

    # TODO are we sure this works? .. we are using == in void context
    @downloader.response_code.should == 200
    html.should_not be_nil
  end

  describe "for Hearings List downloads" do
    it "should download first page of criminal hearings with 100 results" do
      @request = JusticeGovSk::Config::Hearings::CriminalHearingList.new 

      # it is possible to chain methods like .page(1).count(1)
      @request.page(1)
      @request.per_page(100)
    end

    it 'should download first page of civil hearing with 20 results' do
      @request = JusticeGovSk::Config::Hearings::CivilHearingList.new 

      @request.page(1)
      @request.per_page(20)
    end

    it 'should download first page of special criminal hearings page with 50 results' do
      @request = JusticeGovSk::Config::Hearings::SpecialHearingList.new

      @request.page(1)
      @request.per_page(50)
    end
  end

  describe "for Decrees List downloads" do
    it 'should download first page of decrees with 100 results' do
      @request = JusticeGovSk::Config::Decrees::DecreeList.new

      @request.page(1)
      @request.per_page(100)
    end
  end

  describe "for Judges List downloads" do
    it 'should download second page of judges with 100 results' do
      @request = JusticeGovSk::Config::Judges::JudgeList.new

      @request.page(2)
      @request.per_page(100)
    end
  end
end
