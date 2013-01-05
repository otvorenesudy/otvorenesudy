# encoding: utf-8 
require 'spec_helper'

describe JusticeGovSk::Parser::SpecialHearing do 
  it "should parse info about Special hearing" do
    html = load_fixture('hearings/special-hearing.html')

    @parser = JusticeGovSk::Parser::SpecialHearing.new

    document = @parser.parse(html)
  
    @parser.commencement_date(document).should      eql('2012-06-28 10:46:00')
    @parser.selfjudge(document).should              be_false
    @parser.court(document).should                  eql('Špecializovaný trestný súd')
    @parser.chair_judge(document).should            eql({
                                                     unprocessed: "JUDr. Králik",
                                                     altogether:  "JUDr. Králik",
                                                     prefix:      "JUDr.",
                                                     first:       nil,
                                                     middle:      nil,
                                                     last:        "Králik",
                                                     suffix:      nil,
                                                     addition:    nil,
                                                     role:        nil
    })
    @parser.defendant(document).should              eql('Ladislav Bališ a spol.')
    @parser.case_number(document).should            eql('PK-1T 10/12')
    @parser.file_number(document).should            eql('9512100043')
    @parser.date(document).should                   eql('2013-02-11 09:00:00')
    @parser.room(document).should                   eql('PK budova Justičnej akadémie')
    @parser.note(document).should                   be_nil
    @parser.section(document).should                be_nil
    @parser.subject(document).should                eql('§144/1, 3b a iné TZ')
    @parser.form(document).should                   eql('Hlavné pojednávanie')
  end
end
