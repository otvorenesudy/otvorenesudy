# encoding: utf-8
require 'spec_helper_justice_gov_sk'

describe JusticeGovSk do
  
  context "resources" do
    before(:all) do 
      JusticeGovSk.crawl_resources Court, safe: false
      JusticeGovSk.crawl_resources Judge, safe: false
      JusticeGovSk.crawl_resource  SpecialHearing, SPECIAL_HEARING_URL, safe: true
      JusticeGovSk.crawl_resource  CivilHearing, CIVIL_HEARING_URL, safe: true
      JusticeGovSk.crawl_resource  CriminalHearing, CRIMINAL_HEARING_URL, safe: true
      JusticeGovSk.crawl_resource  Decree, DECREE_URL, decree_form: 'A', safe: true
    end

    it "should crawl all courts" do
    
      @court = Court.find_by_name('Okresný súd Bratislava II')

      Court.count.should eql(65)

      @court.name.should eql('Okresný súd Bratislava II')
      @court.uri.should  eql('http://www.justice.gov.sk/Stranky/Sudy/Okresny-sud-Bratislava-II/SudDetail.aspx')
      @court.street.should eql('Drieňova 5')
      @court.phone.should eql('02/48701111')
      @court.fax.should eql('02/48 701 222')
      @court.media_person.should eql('Mgr. Pavol Adamčiak')
      @court.media_person_unprocessed.should eql('Mgr. Pavol Adamčiak')
      @court.media_phone.should eql('02/50118417, 0903 424 263')
      @court.longitude.should eql(17.14747)
      @court.latitude.should eql(48.160389)
      
      @court.type.value.should eql('Okresný')
      @court.municipality.name.should eql('Bratislava II')
      @court.municipality.zipcode.should eql('827 02')
 
      @court.information_center.email.should eql('osba2@justice.sk')
      @court.information_center.phone.should eql('02/48701103')
      @court.information_center.hours_monday.should eql('8:00 - 12:00, 12:30 - 15:00')
      @court.information_center.hours_tuesday.should eql('8:00 - 12:00, 12:30 - 15:00')
      @court.information_center.hours_wednesday.should eql('8:00 - 12:00, 12:30 - 15:00')
      @court.information_center.hours_thursday.should eql('8:00 - 12:00, 12:30 - 14:30')
      @court.information_center.hours_friday.should eql('8:00 - 12:00')
      @court.information_center.note.should nil

      @court.registry_center.email.should eql('podatelnaOSBA2@justice.sk')
      @court.registry_center.phone.should eql('02/48701104')
      @court.registry_center.hours_monday.should eql('8:00 - 15:30')
      @court.registry_center.hours_tuesday.should eql('8:00 - 15:30')
      @court.registry_center.hours_wednesday.should eql('8:00 - 15:30')
      @court.registry_center.hours_thursday.should eql('8:00 - 14:30')
      @court.registry_center.hours_friday.should eql('8:00 - 14:00')
      @court.registry_center.note.should nil

      @court.business_registry_center.should be_nil

      @court = Court.find_by_name('Krajský súd Trnava')

      @court.name.should eql('Krajský súd Trnava')
      @court.uri.should  eql('http://www.justice.gov.sk/Stranky/Sudy/Krajsky-sud-Trnava/SudDetail.aspx')
      @court.street.should eql('Vajanského 2/A')
      @court.phone.should eql('033/5511057-060')
      @court.fax.should eql('033/5512662')
      @court.media_person.should eql('Mgr. Jana Kondákorová')
      @court.media_person_unprocessed.should eql('Mgr. Jana Kondákorová')
      @court.media_phone.should eql('0905 519743')
      @court.longitude.should eql(17.585893)
      @court.latitude.should eql(48.373898)
      
      @court.type.value.should eql('Krajský')
      @court.municipality.name.should eql('Trnava')
      @court.municipality.zipcode.should eql('918 70')
 
      @court.information_center.email.should be_nil
      @court.information_center.phone.should eql('033/5511467')
      @court.information_center.hours_monday.should eql('8:00 - 16:00')
      @court.information_center.hours_tuesday.should eql('8:00 - 16:00')
      @court.information_center.hours_wednesday.should eql('8:00 - 16:00')
      @court.information_center.hours_thursday.should eql('8:00 - 16:00')
      @court.information_center.hours_friday.should eql('8:00 - 15:00')
      @court.information_center.note.should nil

      @court.registry_center.email.should eql('podatelnaKSTT@justice.sk')
      @court.registry_center.phone.should eql('033/5511057 -060')
      @court.registry_center.hours_monday.should eql('8:00 - 16:00')
      @court.registry_center.hours_tuesday.should eql('8:00 - 16:00')
      @court.registry_center.hours_wednesday.should eql('8:00 - 16:00')
      @court.registry_center.hours_thursday.should eql('8:00 - 16:00')
      @court.registry_center.hours_friday.should eql('8:00 - 15:00')
      @court.registry_center.note.should nil

      @court.business_registry_center.should be_nil
    end

    it "should crawl all judges" do
      @judge = Judge.find_by_name('Mgr. Ivan Antal')

      @judge.name.should eql('Mgr. Ivan Antal')
      @judge.name_unprocessed.should eql('ANTAL Ivan, Mgr.')
      @judge.prefix.should eql('Mgr.')
      @judge.first.should eql('Ivan')
      @judge.middle.should be_nil
      @judge.last.should eql('Antal')
      @judge.suffix.should be_nil
      @judge.addition.should be_nil

      @judge.employments.should_not be_empty
      @judge.employments[0].court.name.should eql('Okresný súd Rimavská Sobota')
      @judge.employments[0].judge_position.value.should eql('podpredseda')
      @judge.judge_positions.should_not be_empty
      @judge.judge_positions[0].value.should eql('podpredseda')
    end

    it "should crawl special hearing" do
      @hearing = SpecialHearing.first
  
      @hearing.uri.should eql(SPECIAL_HEARING_URL)
      @hearing.case_number.should eql('PK-1T 14/07')
      @hearing.file_number.should eql('9507100043')
      #@hearing.date.should eql('2013-01-07 08:00:00')
      #@hearing.commencement_date.should eql('2012-08-19 22:00:00')
      @hearing.note.should be_nil
      @hearing.room.should eql('Pezinok/ poj.miest. č. I, č.dv. 130b')
      @hearing.special_type.should be_nil
      @hearing.section.should be_nil
      @hearing.form.value.should eql('Hlavné pojednávanie')
      
      @hearing.judgings.size.should eql(1)
      @hearing.judgings[0].judge_name_similarity.should eql(0.71)
      @hearing.judgings[0].judge_name_unprocessed.should eql('JUDr. KRÁLIK')
      @hearing.judgings[0].judge_chair.should be_true
      @hearing.judgings[0].judge.name.should eql('JUDr. Igor Králik')

      @hearing.proposers.should be_empty
      @hearing.opponents.should be_empty
      @hearing.defendants.size.should eql(1)
      @hearing.defendants[0].name.should eql('obž. Róbert Okoličány a spol.')
    end

    it "should crawl civil hearing" do
      @hearing = CivilHearing.first

      @hearing.uri.should eql(CIVIL_HEARING_URL)
      @hearing.case_number.should eql('1Sd/69/2012')
      @hearing.file_number.should eql('7012201131')
      #@hearing.date.should eql('2013-01-04 07:30:00')
      @hearing.commencement_date.should be_nil
      @hearing.note.should be_nil
      @hearing.room.should be_nil
      @hearing.special_type.should eql('Sd')
      @hearing.section.value.should eql('S')
      @hearing.form.value.should eql('Pojednávanie')

      @hearing.judgings.size.should eql(1)
      @hearing.judgings[0].judge_name_similarity.should eql(1.0)
      @hearing.judgings[0].judge_name_unprocessed.should eql('JUDr. Milan Konček')
      @hearing.judgings[0].judge_chair.should be_false
      @hearing.judgings[0].judge.name.should eql('JUDr. Milan Konček')

      @hearing.proposers.size.should eql(1)
      @hearing.proposers[0].name.should eql('Róbert Fehér')
      @hearing.opponents.size.should eql(1)
      @hearing.opponents[0].name.should eql('Sociálna poisťovňa, ústredie Bratislava')
      @hearing.defendants.should be_empty
    end

    it "should crawl criminal hearing" do
      @hearing = CriminalHearing.first

      @hearing.uri.should eql(CRIMINAL_HEARING_URL)
      @hearing.case_number.should eql('4T/159/2012')
      @hearing.file_number.should eql('1512010942')
      #@hearing.date.should eql('2013-01-04 08:00:00')
      @hearing.commencement_date.should be_nil
      @hearing.note.should be_nil
      @hearing.room.should eql('2002')
      @hearing.special_type.should be_nil
      @hearing.section.value.should eql('Trestný') 
      @hearing.form.value.should eql('Verejné zasadnutie')

      @hearing.judgings.size.should eql(1)
      @hearing.judgings[0].judge_name_similarity.should eql(1.0)
      @hearing.judgings[0].judge_chair.should be_false
      @hearing.judgings[0].judge.name.should eql('JUDr. Zuzana Bartalská')

      @hearing.proposers.should be_empty
      @hearing.opponents.should be_empty
      @hearing.defendants.size.should eql(2)
      @hearing.defendants[0].name.should eql('Mário Janata')
      @hearing.defendants[1].name.should eql('Maroš Malec')
    end

    it "should crawl decree" do
      pending 'implement test for decree'

      @decree = Decree.first

      @decree.uri.should eql(DECREE_URL)
      @decree.case_number.should eql('1T/199/2012')
      @decree.file_number.should eql('7812010519')
      #TODO: @decree.date....
      @decree.ecli.should eql('ECLI:SK:OSZA:2013:5112893534.1')
      @decree.text.should_not be_nil

      @decree.legislation_area.value.should eql('Trestné právo')
      @decree.legislation_subarea.value.should eql('Život a zdravie')
      @decree.legislation_usages.size.should eql(3)
      @decree.legislation_usages[0].legislation.value eql('Zákon č. 300/2005, § 172, Odsek 1, Písmeno a')
      @decree.legislation_usages[1].legislation.value eql('Zákon č. 300/2005, § 172, Odsek 1, Písmeno d')
      @decree.legislation_usages[2].legislation.value eql('Zákon č. 313/2011 2011')
      
      @decree.court.name.should eql('Okresný súd Rožňava')
      
      @decree.judges.size.should eql(1)
      @decree.judges[0].name.should eql('JUDr. Ján Gallo')

      @decree.form.value.should eql('Rozsudok')
      @decree.nature.value.should eql('Prvostupňové nenapadnuté opravnými prostriedkami')
    end
  end

end
