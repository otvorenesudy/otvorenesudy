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

    @downloader.response_code.should == 200
    html.should_not be_nil
  end

  it "should download first page of criminal hearings with 100 results" do
    @request = JusticeGovSk::Config::Hearings::CriminalList.new 
    
    # it is possible to chain methods like .page(1).count(1)
    @request.page(1)
    @request.count(100)
  end

  it 'should download first page of civil hearing with 20 results' do
    @request = JusticeGovSk::Config::Hearings::CivilList.new 
    
    @request.page(1)
    @request.count(20)
  end

  it 'should download first page of special criminal hearings page with 50 results' do
    @request = JusticeGovSk::Config::Hearings::SpecialCriminalList.new

    @request.page(1)
    @request.count(50)
  end
end
