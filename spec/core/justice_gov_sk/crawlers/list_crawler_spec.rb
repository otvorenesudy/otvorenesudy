require 'crawler_spec_helper'

describe JusticeGovSk::Crawlers::ListCrawler do 
  before :each do 
    @agent     = mock(JusticeGovSk::Agents::ListAgent.new)
    @persistor = mock(Persistor.new)
    @parser    = mock(JusticeGovSk::Parsers::ListParser.new)    
  end

  it "should crawl second page of decree list" do
    @request   = mock(JusticeGovSk::Requests::DecreeListRequest.new)
    
    @request.should_receive(:page).and_return(2)
    @request.should_receive(:per_page).and_return(100)
     
    @agent.should_receive(:download).with(@request).and_return(@html)

    @parser.should_receive(:parse).with(@html).and_return(@document)
    @parser.should_receive(:page).and_return(2)
    @parser.should_receive(:pages).and_return(3567)
    @parser.should_receive(:per_page).and_return(100)
    @parser.should_receive(:next_page).and_return(3)
    @parser.should_receive(:list).with(@document)

    crawler = JusticeGovSk::Crawlers::ListCrawler.new @agent, @parser, @persistor

    @persistor.should_receive(:verbose=).with(false)
    @parser.should_receive(:verbose=).with(false)
    @agent.should_receive(:verbose=).with(false)
    
    crawler.verbose = false
    crawler.crawl @request
  end

  it "should crawl and process each list item from page of decree list" do
    @request = mock(JusticeGovSk::Requests::DecreeListRequest.new)

    @request.should_receive(:page=).and_return(3512)
   
    crawler = JusticeGovSk::Crawlers::ListCrawler.new @agent, @parser, @persistor
   
    @persistor.should_receive(:verbose=).with(false)
    @parser.should_receive(:verbose=).with(false)
    @agent.should_receive(:verbose=).with(false)

    crawler.verbose = false
    crawler.crawl_and_process @request, 3512, 0
  end
end
