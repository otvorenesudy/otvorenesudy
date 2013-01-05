# encoding: utf-8
require 'spec_helper'

describe JusticeGovSk::Parser::CriminalHearing do 
  it "should parse information about Criminal hearing" do
    
    html = load_fixture('hearings/criminal-hearing.html')
  
    @parser = JusticeGovSk::Parser::CriminalHearing.new 

    document = @parser.parse(html)
    
    @parser.case_number(document).should   eql('1T/73/2012')
    @parser.file_number(document).should   eql('6712010324')
    @parser.date(document).should          eql('2012-11-14 08:00:00')
    @parser.room(document).should          eql('7')
    @parser.note(document).should          be_nil
    @parser.section(document).should       eql('Trestný')
    @parser.court(document).should         eql('Okresný súd Zvolen')
    @parser.judges(document).should        eql([{
                                               unprocessed: "JUDr.                                              Mariana                                            Philadelphyová", 
                                               altogether:  "JUDr. Mariana Philadelphyová",
                                               prefix:      "JUDr.",
                                               first:       "Mariana",
                                               middle:      nil,
                                               last:        "Philadelphyová",
                                               suffix:      nil,
                                               addition:    nil,
                                               role:        nil
    }])
    @parser.subject(document).should       eql('Obžaloba')
    @parser.form(document).should          eql('Hlavné pojednávanie')

    @parser.defendants(document).keys.should               eql(['Alexander Kováč', 'Miroslav Kováč'])
    @parser.defendants(document)["Alexander Kováč"].should eql(['§ 364 odsek 1 písmeno a Trestného zákona číslo 300/2005 Zbierky zákonov v znení zákona číslo 313/2011 Zbierky zákonov'])
    @parser.defendants(document)["Miroslav Kováč"].should  eql(['§ 364 odsek 1 písmeno a Trestného zákona číslo 300/2005 Zbierky zákonov v znení zákona číslo 313/2011 Zbierky zákonov'])  
  end
end
