# Sources
source = Source.find_or_initialize_by_module('JusticeGovSk')
source.name = 'Ministerstvo spravodlivosti Slovenskej republiky'
source.uri = 'http://www.justice.gov.sk'
source.save!

source = Source.find_or_initialize_by_module('NrsrSk')
source.name = 'Národná rada Slovenskej republiky'
source.uri = 'http://www.nrsr.sk'
source.save!

source = Source.find_or_initialize_by_module('PrezidentSk')
source.module = 'PrezidentSk'
source.name = 'Prezident Slovenskej republiky'
source.uri = 'http://www.prezident.sk'
source.save!

source = Source.find_or_initialize_by_module('SudnaradaGovSk')
source.name = 'Súdna rada Slovenskej republiky'
source.uri = 'http://www.sudnarada.gov.sk'
source.save!

seeds = Source.find_or_initialize_by_module('seeds')
seeds.name = 'Database seeds file'
seeds.uri = 'db/seeds.rb'
seeds.save!

# Courts
#court              = Court.new
#court.uri          = 'http://portal.concourt.sk'
#court.source       = seeds
#court.type         = CourtType.constitutional
#court.municipality = Municipality.create name: 'Košice', zipcode: '042 65'
#court.name         = 'Ústavný súd Slovenskej republiky'
#court.street       = 'Hlavná 110'
#court.latitude     = 48.725868
#court.longitude    = 21.25517
#court.save!
#court.registry_center                 = CourtOffice.new
#court.registry_center.court           = court
#court.registry_center.type            = CourtOfficeType.registry_center
#court.registry_center.email           = nil
#court.registry_center.phone           = '+421-55-7207211, +421-55-6227633'
#court.registry_center.hours_monday    = '7:30 - 12:00, 13:00 - 16:00'
#court.registry_center.hours_tuesday   = '7:30 - 12:00, 13:00 - 16:00'
#court.registry_center.hours_wednesday = '7:30 - 12:00, 13:00 - 16:00'
#court.registry_center.hours_thursday  = '7:30 - 12:00, 13:00 - 16:00'
#court.registry_center.hours_friday    = '7:30 - 12:00, 13:00 - 13:30'
#court.registry_center.save!
#court.save!

municipality = Municipality.find_or_initialize_by_name('Bratislava')
municipality.zipcode = '814 90'
municipality.save!

court = Court.find_or_initialize_by_uri('http://www.nsud.sk')
court.source = seeds
court.type = CourtType.supreme
court.municipality = municipality
court.name = 'Najvyšší súd Slovenskej republiky'
court.street = 'Župné námestie č. 13'
court.latitude = 48.145895
court.longitude = 17.104694
court.save!
court.registry_center =
  CourtOffice.find_or_initialize_by_court_id_and_court_office_type_id(court.id, CourtOfficeType.registry_center.id)
court.registry_center.email = 'podatelna@nsud.sk, info@nsud.sk'
court.registry_center.phone = '02/32 304 660'
court.registry_center.hours_monday = '8:00 - 11:30, 12:00 - 15:30'
court.registry_center.hours_tuesday = '8:00 - 11:30, 12:00 - 15:30'
court.registry_center.hours_wednesday = '8:00 - 11:30, 12:00 - 15:30'
court.registry_center.hours_thursday = '8:00 - 11:30, 12:00 - 15:30'
court.registry_center.hours_friday = '8:00 - 11:30, 12:00 - 15:30'
court.registry_center.save!
court.save!

# Decrees
DecreeForm.find_or_create_by_value('Rozsudok').update_attributes!(code: 'A')
DecreeForm.find_or_create_by_value('Rozhodnutie').update_attributes!(code: 'A')
DecreeForm.find_or_create_by_value('Uznesenie').update_attributes!(code: 'N')
DecreeForm.find_or_create_by_value('Opravné uznesenie').update_attributes!(code: 'R')
DecreeForm.find_or_create_by_value('Dopĺňacie uznesenie').update_attributes!(code: 'R')
DecreeForm.find_or_create_by_value('Dopĺňací rozsudok').update_attributes!(code: 'D')
DecreeForm.find_or_create_by_value('Platobný rozkaz').update_attributes!(code: 'P')
DecreeForm.find_or_create_by_value('Zmenkový platobný rozkaz').update_attributes!(code: 'M')
DecreeForm.find_or_create_by_value('Európsky platobný rozkaz').update_attributes!(code: 'E')
DecreeForm.find_or_create_by_value('Šekový platobný rozkaz').update_attributes!(code: 'S')
DecreeForm.find_or_create_by_value('Rozkaz na plnenie').update_attributes!(code: 'L')
DecreeForm.find_or_create_by_value('Rozsudok pre zmeškanie').update_attributes!(code: 'K')
DecreeForm.find_or_create_by_value('Rozsudok pre uznanie').update_attributes!(code: 'U')
DecreeForm.find_or_create_by_value('Rozsudok bez odôvodnenia').update_attributes!(code: 'F')
DecreeForm.find_or_create_by_value('Uznesenie bez odôvodnenia').update_attributes!(code: 'C')
DecreeForm.find_or_create_by_value('Osvedčenie').update_attributes!(code: 'B')
DecreeForm.find_or_create_by_value('Trestný rozkaz').update_attributes!(code: 'T')
DecreeForm.find_or_create_by_value('Opatrenie bez poučenia').update_attributes!(code: 'X') # TODO
DecreeForm.find_or_create_by_value('Rozsudok pre vzdanie').update_attributes!(code: 'X') # TODO
DecreeForm.find_or_create_by_value('Čiastočný rozsudok').update_attributes!(code: 'X') # TODO
DecreeForm.find_or_create_by_value('Medzitýmny rozsudok').update_attributes!(code: 'X') # TODO
DecreeForm.find_or_create_by_value('Opatrenie').update_attributes!(code: 'X') # TODO

# Enumerable Values
CourtOfficeType
HearingType
CourtType
Period
