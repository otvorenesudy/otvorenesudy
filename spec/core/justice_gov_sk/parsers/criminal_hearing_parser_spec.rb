# encoding: utf-8
require 'spec_helper'

describe JusticeGovSk::Parsers::CriminalHearingParser do 
  it "should parse information about Criminal hearing" do
    
    html = load_fixture('hearings/criminal-hearing.html')
  
    @parser = JusticeGovSk::Parsers::CriminalHearingParser.new 
    @parser.verbose = false

    document = @parser.parse(html)
    
    @parser.type(document).should          be_eql "Trestné"
    @parser.case_number(document).should   be_eql '1T/73/2012'
    @parser.file_number(document).should   be_eql '6712010324'
    @parser.date(document).should          be_eql '2012-11-14 08:00:00'
    @parser.room(document).should          be_eql '7'
    @parser.note(document).should          be_nil
    @parser.section(document).should       be_eql 'Trestný'
    @parser.court(document).should         be_eql 'Okresný súd Zvolen'
    @parser.judges(document).should        be_eql ['JUDr. Mariana Philadelphyová']
    @parser.subject(document).should       be_eql 'Obžaloba'
    @parser.form(document).should          be_eql 'Hlavné pojednávanie'

    @parser.defendants(document).keys.should               be_eql ['Alexander Kováč', 'Miroslav Kováč']
    @parser.defendants(document)["Alexander Kováč"].should be_eql ['§ 364 odsek 1 písmeno a Trestného zákona číslo 300/2005 Zbierky zákonov v znení zákona číslo 313/2011 Zbierky zákonov']
    @parser.defendants(document)["Miroslav Kováč"].should  be_eql ['§ 364 odsek 1 písmeno a Trestného zákona číslo 300/2005 Zbierky zákonov v znení zákona číslo 313/2011 Zbierky zákonov']   
  end
end
