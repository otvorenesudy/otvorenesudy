# encoding: utf-8
require 'spec_helper'

describe "Downloader" do 
  it "should download first page of hearings with 100 results" do
    downloader = Downloader.new

    Justicegovsk::Config::Hearings::Criminal.page(1)
    Justicegovsk::Config::Hearings::Criminal.count(100)

    downloader.headers = Justicegovsk::Config::Hearings::Criminal.headers
    downloader.data = Justicegovsk::Config::Hearings::Criminal.data
    
    data = downloader.download(Justicegovsk::Config::Hearings::Criminal.url)

    data.should_not be_nil
  end
end
