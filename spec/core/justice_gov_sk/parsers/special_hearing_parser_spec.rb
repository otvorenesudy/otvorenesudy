# encoding: utf-8 
require 'spec_helper'

describe JusticeGovSk::Parsers::SpecialHearingParser do 
  it "should parse info about Special hearing" do
    html = load_fixture('hearings/special-hearing.html')

    @parser = JusticeGovSk::Parsers::SpecialHearingParser.new
    @parser.verbose = false

    document = @parser.parse(html)
  
    @parser.type(document).should                   be_eql 'Špecializovaného trestného súdu'
    @parser.commencement_date(document).should      be_eql '2012-06-28 10:46:00'
    @parser.selfjudge(document).should              be_eql false
    @parser.court(document).should                  be_eql 'Špecializovaný trestný súd'
    @parser.chair_judge(document).should            be_eql 'JUDr. Králik'
    @parser.defendant(document).should              be_eql 'Ladislav Bališ a spol.'
    @parser.case_number(document).should            be_eql 'PK-1T 10/12'
    @parser.file_number(document).should            be_eql '9512100043'
    @parser.date(document).should                   be_eql '2013-02-11 09:00:00'
    @parser.room(document).should                   be_eql 'PK budova Justičnej akadémie'
    @parser.note(document).should                   be_nil
    @parser.section(document).should                be_nil
    @parser.subject(document).should                be_eql '§144/1, 3b a iné TZ'
    @parser.form(document).should                   be_eql 'hlavné pojednávanie'
  end
end

