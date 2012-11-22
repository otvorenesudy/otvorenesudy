# encoding: utf-8
require 'spec_helper'

describe JusticeGovSk::Parsers::CourtParser do 
  it "should parse information about specific Court" do
    html = load_fixture('courts/court.html')

    @parser = JusticeGovSk::Parsers::CourtParser.new
    @parser.verbose = false

    document = @parser.parse(html)

    @parser.type(document).should                              be_eql 'Krajský'
    @parser.municipality_name(document).should                 be_eql 'Trenčín'
    @parser.municipality_zipcode(document).should              be_eql '911 50'
    @parser.name(document).should                              be_eql 'Krajský súd Trenčín'
    #@parser.street(document).strip.should                      be_eql 'Nám. sv. Anny 28'
    @parser.phone(document).should                             be_eql '032/6572811'
    @parser.fax(document).should                               be_eql '032/6582342'
    @parser.media_person(document)[:name].should               be_eql 'Mgr. Roman Tarabus'  
    @parser.media_person(document)[:name_unprocessed].should   be_eql 'Mgr. Roman Tarabus'  
    @parser.media_phone(document).should                       be_eql '032/6572858; 0911 273 834' 
    
    @parser.office_phone(:information_center, document).should  be_eql '032/6572860'
    @parser.office_email(:information_center, document).should  be_eql 'podatelnaKSTN@justice.sk'
    @parser.office_note(:information_center, document).should   be_nil
    @parser.office_hours(:information_center, document).each do |_, value|
      value.should be_eql '7:00 - 15:00'
    end
    
    @parser.office_phone(:registry_center, document).should  be_eql '032/6572811'
    @parser.office_email(:registry_center, document).should  be_eql 'podatelnaKSTN@justice.sk'
    @parser.office_note(:registry_center, document).should   be_nil
    @parser.office_hours(:registry_center, document).each do |_, value|
      value.should be_eql '7:00 - 15:00'
    end

    @parser.latitude(document).should    be_eql '48771560'
    @parser.longitude(document).should   be_eql '18619879'
  end
end
