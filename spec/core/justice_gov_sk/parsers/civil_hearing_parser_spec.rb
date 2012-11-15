# encoding: utf-8
require 'spec_helper'

describe JusticeGovSk::Parsers::CivilHearingParser do 
  it "should parse information about Civil hearing" do
    url = "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieDetail.aspx?IdVp=121951138"
    
    html = load_fixture('hearings/civil-hearing.html')

    @parser = JusticeGovSk::Parsers::CivilHearingParser.new
    @parser.verbose = false

    document = @parser.parse(html)
      
    @parser.should_not                     be_nil
    @parser.type(document).should          be_eql 'Civilné'
    @parser.special_type(document).should  be_eql 'S'
    @parser.proposers(document).should     be_eql ['Bíli Andeli, o.z., Trnava']
    @parser.opponents(document).should     be_eql ['Úrad priemyselného vlastníctva SR B.Bystrica']
    @parser.case_number(document).should   be_eql '23S/13/2012'
    @parser.file_number(document).should   be_eql '6012200131'
    @parser.date(document).should          be_eql '2012-11-14 08:15:00'
    @parser.room(document).should          be_eql '103 - Skuteckeho 10'
    @parser.note(document).should          be_nil
    @parser.section(document).should       be_eql 'S'
    @parser.court(document).should         be_eql 'Krajský súd Banská Bystrica'
    @parser.judges(document).should        be_eql ['JUDr. Milan Segeč']
    @parser.subject(document).should       be_eql 'žaloba č. POZ 321-2009 II/130-2011'
    @parser.form(document).should          be_eql 'Verejné vyhlásenie rozsudku'
  end
end
