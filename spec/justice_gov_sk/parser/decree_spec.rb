# encoding: utf-8
require 'spec_helper'

describe JusticeGovSk::Parser::Decree do 
  it "should parse information about specific Decree" do
    html = load_fixture('decrees/decree.html')

    @parser = JusticeGovSk::Parser::Decree.new

    document = @parser.parse(html)

    @parser.case_number(document).should          eql('3T/139/2012')
    @parser.file_number(document).should          eql('3112011623')
    @parser.date(document).should                 eql('2012-11-13')
    @parser.ecli(document).should                 eql('ECLI:SK:OSTN:2012:3112011623.1')
    @parser.court(document).should                eql('Okresný súd Trenčín')
    @parser.judge(document).should                eql({
                                                     unprocessed: "JUDr. Eva Tóthová",
                                                     altogether:  "JUDr. Eva Tóthová",
                                                     prefix:      "JUDr.",
                                                     first:       "Eva",
                                                     middle:      nil,
                                                     last:        "Tóthová",
                                                     suffix:      nil,
                                                     addition:    nil,
                                                     role:        nil
    })
    @parser.nature(document).should               eql('Prvostupňové nenapadnuté opravnými prostriedkami')
    @parser.legislation_area(document).should     eql('Trestné právo')
    @parser.legislation_subarea(document).should  eql('Majetok')
    @parser.legislations(document).should         eql(['Zákon č. 300/2005 Trestný zákon'])
  end

  it "should parse information about specific Decree with multiple legislations" do 
    pending("waiting for being implemented ...")
  end
end
