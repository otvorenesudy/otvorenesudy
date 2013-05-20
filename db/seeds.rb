# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# sources
source        = Source.new
source.module = "JusticeGovSk"
source.name   = "Portál ministerstva spravodlivosti Slovenskej republiky"
source.uri    = "http://www.justice.gov.sk"
source.save!

source        = Source.new
source.module = "SudnaradaGovSk"
source.name   = "Portál súdnej rady Slovenskej republiky"
source.uri    = "http://mps.sudnarada.gov.sk"
source.save!

source        = Source.new
source.module = "NrsrSk"
source.name   = "Národná rada Slovenskej republiky"
source.uri    = "http://nrsr.sk"
source.save!

seeds        = Source.new
seeds.module = "seeds"
seeds.name   = "Database seeds file"
seeds.uri    = "db/seeds.rb"
seeds.save!

# courts

# http://portal.concourt.sk/pages/viewpage.action?pageId=1278049
court              = Court.new
court.uri          = "http://portal.concourt.sk"
court.source       = seeds
court.type         = CourtType.constitutional
court.municipality = Municipality.create name: "Košice", zipcode: "042 65"
court.name         = "Ústavný súd Slovenskej republiky"
court.street       = "Hlavná 110"
court.latitude     = 48.725868
court.longitude    = 21.25517
court.save!
court.registry_center                 = CourtOffice.new
court.registry_center.court           = court
court.registry_center.type            = CourtOfficeType.registry_center
court.registry_center.email           = nil
court.registry_center.phone           = "+421-55-7207211, +421-55-6227633" # TODO format
court.registry_center.hours_monday    = "7:30 - 12:00, 13:00 - 16:00"
court.registry_center.hours_tuesday   = "7:30 - 12:00, 13:00 - 16:00"
court.registry_center.hours_wednesday = "7:30 - 12:00, 13:00 - 16:00"
court.registry_center.hours_thursday  = "7:30 - 12:00, 13:00 - 16:00"
court.registry_center.hours_friday    = "7:30 - 12:00, 13:00 - 13:30"
court.registry_center.save!
court.save!

# http://www.nsud.sk/kontakt/
court              = Court.new
court.uri          = "http://www.nsud.sk"
court.source       = seeds
court.type         = CourtType.highest
court.municipality = Municipality.create name: "Bratislava", zipcode: "814 90"
court.name         = "Najvyšší súd Slovenskej republiky"
court.street       = "Župné námestie č. 13"
court.latitude     = 48.145895
court.longitude    = 17.104694
court.save!
court.registry_center                 = CourtOffice.new
court.registry_center.court           = court
court.registry_center.type            = CourtOfficeType.registry_center
court.registry_center.email           = "podatelna@nsud.sk, info@nsud.sk"
court.registry_center.phone           = "02 / 323 04 660" # TODO format
court.registry_center.hours_monday    = "8:00 - 11:30, 12:00 - 15:30"
court.registry_center.hours_tuesday   = "8:00 - 11:30, 12:00 - 15:30"
court.registry_center.hours_wednesday = "8:00 - 11:30, 12:00 - 15:30"
court.registry_center.hours_thursday  = "8:00 - 11:30, 12:00 - 15:30"
court.registry_center.hours_friday    = "8:00 - 11:30, 12:00 - 15:30"
court.registry_center.save!
court.save!

# decrees

DecreeForm.create value: "Rozsudok",                  code: 'A'
DecreeForm.create value: "Uznesenie",                 code: 'N'
DecreeForm.create value: "Opravné uznesenie",         code: 'R'
DecreeForm.create value: "Dopĺňací rozsudok",         code: 'D'
DecreeForm.create value: "Platobný rozkaz",           code: 'P'
DecreeForm.create value: "Zmenkový platobný rozkaz",  code: 'M'
DecreeForm.create value: "Európsky platobný rozkaz",  code: 'E'
DecreeForm.create value: "Šekový platobný rozkaz",    code: 'S'
DecreeForm.create value: "Rozkaz na plnenie",         code: 'L'
DecreeForm.create value: "Rozsudok pre zmeškanie",    code: 'K'
DecreeForm.create value: "Rozsudok pre uznanie",      code: 'U'
DecreeForm.create value: "Rozsudok bez odôvodnenia",  code: 'F' 
DecreeForm.create value: "Uznesenie bez odôvodnenia", code: 'C'
DecreeForm.create value: "Osvedčenie",                code: 'B'
DecreeForm.create value: "Trestný rozkaz",            code: 'T'
