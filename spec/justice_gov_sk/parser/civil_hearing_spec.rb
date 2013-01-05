# encoding: utf-8
require 'spec_helper'

describe JusticeGovSk::Parser::CivilHearing do 
  it "should parse information about Civil hearing" do
    url = "#{JusticeGovSk::URL.base}/Stranky/Pojednavania/PojednavanieDetail.aspx?IdVp=121951138"
    
    html = load_fixture('hearings/civil-hearing.html')

    @parser = JusticeGovSk::Parser::CivilHearing.new

    document = @parser.parse(html)
      
    @parser.should_not                     be_nil
    @parser.special_type(document).should  eql('S')
    @parser.proposers(document).should     eql(['Bíli Andeli, o.z., Trnava'])
    @parser.opponents(document).should     eql(['Úrad priemyselného vlastníctva SR B. Bystrica'])
    @parser.case_number(document).should   eql('23S/13/2012')
    @parser.file_number(document).should   eql('6012200131')
    @parser.date(document).should          eql('2012-11-14 08:15:00')
    @parser.room(document).should          eql('103 - Skuteckeho 10')
    @parser.note(document).should          be_nil
    @parser.section(document).should       eql('S')
    @parser.court(document).should         eql('Krajský súd Banská Bystrica')
    @parser.judges(document).should        eql([{
                                               unprocessed: "JUDr. Milan Segeč", 
                                               altogether:  "JUDr. Milan Segeč",
                                               prefix:      "JUDr.",
                                               first:       "Milan",
                                               middle:      nil,
                                               last:        "Segeč",
                                               suffix:      nil,
                                               addition:    nil,
                                               role:        nil
    }])
    @parser.subject(document).should       eql('žaloba č. POZ 321-2009 II/130-2011')
    @parser.form(document).should          eql('Verejné vyhlásenie rozsudku')
  end
end
