require 'agent_spec_helper'

describe JusticeGovSk::Agent::Document do 
  before :each do 
    @agent = JusticeGovSk::Agent::Document.new

    @agent.wait_time = 0
  end

  after :each do 
    document = @agent.download(@request)

    document.content.should_not be_nil
    document.content.should_not be_empty
  end
  
  it "should download document for specific Decree" do
    @request = JusticeGovSk::Request::Document.new
    
    @request.format = :pdf
    @request.url = "http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail.aspx?PorCis=0374BFEA-B34C-4BB8-BC83-21DF2A3E3AFA&PojCislo=478689"
  end
end
