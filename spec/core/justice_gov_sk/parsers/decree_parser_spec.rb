# encoding: utf-8
require 'spec_helper'

describe JusticeGovSk::Parsers::DecreeParser do 
  it "should parse information about specific Decree" do
    html = load_fixture('decrees/decree.html')

    @parser = JusticeGovSk::Parsers::DecreeParser.new
    @parser.verbose = false

    document = @parser.parse(html)

    @parser.case_number(document).should          be_eql '3T/139/2012'
    @parser.file_number(document).should          be_eql '3112011623'
    @parser.date(document).should                 be_eql '2012-11-13'
    @parser.ecli(document).should                 be_eql 'ECLI:SK:OSTN:2012:3112011623.1'
    @parser.court(document).should                be_eql 'Okresný súd Trenčín'
    @parser.judge(document).should                be_eql 'JUDr. Eva Tóthová'
    @parser.nature(document).should               be_eql 'Prvostupňové nenapadnuté opravnými prostriedkami'
    @parser.legislation_area(document).should     be_eql 'Trestné právo'
    @parser.legislation_subarea(document).should  be_eql 'Majetok'
    @parser.legislations(document).should         be_eql ['Zákon č. 300/2005 Trestný zákon']
  end

  it "should parse information about specific Decree with multiple legislations" do 
    pending("waiting for being implemented ...")
  end
end
