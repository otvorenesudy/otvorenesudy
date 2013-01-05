# encoding: utf-8
require 'spec_helper'

#TODO: fix test for street
describe JusticeGovSk::Parser::Court do 
  it "should parse information about specific Court" do
    html = load_fixture('courts/court.html')

    @parser = JusticeGovSk::Parser::Court.new

    document = @parser.parse(html)

    @parser.type(document).should                              eql('Krajský')
    @parser.municipality_name(document).should                 eql('Trenčín')
    @parser.municipality_zipcode(document).should              eql('911 50')
    @parser.name(document).should                              eql('Krajský súd Trenčín')
    #@parser.street(document).should                            eql('Nám. sv. Anny 28')
    @parser.phone(document).should                             eql('032/6572811')
    @parser.fax(document).should                               eql('032/6582342')
    @parser.media_person(document)[:name].should               eql('Mgr. Roman Tarabus')
    @parser.media_person(document)[:name_unprocessed].should   eql('Mgr. Roman Tarabus') 
    @parser.media_phone(document).should                       eql('032/6572858; 0911 273 834')
    
    @parser.office_phone(CourtOfficeType.information_center, document).should  eql('032/6572860')
    @parser.office_email(CourtOfficeType.information_center, document).should  eql('podatelnaKSTN@justice.sk')
    @parser.office_note(CourtOfficeType.information_center, document).should   be_nil
    @parser.office_hours(CourtOfficeType.information_center, document).each do |_, value|
      value.should eql('7:00 - 15:00')
    end
    
    @parser.office_phone(CourtOfficeType.registry_center, document).should  eql('032/6572811')
    @parser.office_email(CourtOfficeType.registry_center, document).should  eql('podatelnaKSTN@justice.sk')
    @parser.office_note(CourtOfficeType.registry_center, document).should   be_nil
    @parser.office_hours(CourtOfficeType.registry_center, document).each do |_, value|
      value.should eql('7:00 - 15:00')
    end

    @parser.latitude(document).should    eql('48.889383')
    @parser.longitude(document).should   eql('18.035517')
  end
end
