# encoding: utf-8
require 'spec_helper'

describe JusticeGovSk::Parsers::JudgeListParser do 
  it "should get information about judges from list of judges" do
    html = load_fixture('judges/judges_list.html')
  
    @parser = JusticeGovSk::Parsers::JudgeListParser.new
    @parser.verbose = false

    document = @parser.parse(html)

    @parser.page(document).should         be_eql 5
    @parser.per_page(document).should     be_eql 100
    @parser.pages(document).should        be_eql 15 
    @parser.next_page(document).should    be_eql 6

    list = @parser.list(document)

    data = @parser.data(list[4])

    data[:court].should     be_eql 'KRAJSKÝ SÚD V BRATISLAVE'
    data[:name].should      be_eql 'JUDr. Margita Horná'
    data[:position].should  be_eql 'sudca'
    data[:active].should    be_true
    #data[:note].should      be_eql 'od 1. decembra 2009 má prerušený výkon funkcie sudcu podľa § 24 ods. 4 zákona č. 385/2000 Z.z'
  end
end

