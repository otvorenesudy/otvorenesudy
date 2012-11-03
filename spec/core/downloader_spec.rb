# encoding: utf-8
require 'spec_helper'

describe "Downloader" do 
  it "should download first page of hearings with 100 results" do
    request = JusticeGovSk::Config::Hearings::CriminalList.new 
    downloader = Downloader.new

    downloader.wait_time = 0.seconds

    # it is possible to chain methods like .page(1).count(1)
    request.page(1)
    request.count(100)

    downloader.headers = request.headers
    downloader.data = request.data
    
    data = downloader.download(request.url)

    data.should_not be_nil
  end
end
