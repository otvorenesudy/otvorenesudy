# encoding: utf-8
require 'spec_helper'

describe JusticeGovSk::Parser::JudgeList do 
  it "should get information about judges from list of judges" do
    html = load_fixture('judges/judges_list.html')
  
    @parser = JusticeGovSk::Parser::JudgeList.new

    document = @parser.parse(html)

    @parser.page(document).should         eql(5)
    @parser.per_page(document).should     eql(100)
    @parser.pages(document).should        eql(15) 
    @parser.next_page(document).should    eql(6)

    list = @parser.list(document)

    list.length.should      eql(100)

    data = @parser.data(list[4])

    data[:court].should     eql('Krajský súd Bratislava')
    data[:name].should      eql(
                               unprocessed: "HORNÁ Margita, JUDr.",
                               altogether:  "JUDr. Margita Horná",
                               prefix:      "JUDr.",
                               first:       "Margita",
                               middle:      nil,
                               last:        "Horná",
                               suffix:      nil,
                               addition:    nil,
                               role:        nil
    )
    data[:position].should  eql('sudca')
    data[:active].should    be_false
    data[:note].should      eql('od 1. decembra 2009 má prerušený výkon funkcie sudcu podľa § 24 ods. 4 zákona č. 385/2000 Z.z.')

    data = @parser.data(list[86])

    data[:court].should     eql('Okresný súd Považská Bystrica')
    data[:name].should      eql(
                               unprocessed: "JANKOVSKÝ Róbert, JUDr.",
                               altogether:  "JUDr. Róbert Jankovský",
                               prefix:      "JUDr.",
                               first:       "Róbert",
                               middle:      nil,
                               last:        "Jankovský",
                               suffix:      nil,
                               addition:    nil,
                               role:        nil
    )   
    data[:position].should  eql('podpredseda')
    data[:active].should    be_true
    data[:note].should      be_nil
  end
end

