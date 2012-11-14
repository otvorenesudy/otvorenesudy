# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

court              = Court.new
court.uri          = "http://www.nsud.sk" 
court.type         = CourtType.create value: "Najvyšší"  
court.municipality = Municipality.create name: "Bratislava", zipcode: "81490"
court.name         = "Najvyšší súd Slovenskej republiky"
court.street       = "Župné námestie 13"
court.save!

court              = Court.new
court.uri          = "http://portal.concourt.sk"
court.type         = CourtType.create value: "Ústavný"  
court.municipality = Municipality.create name: "Košice", zipcode: "04265"
court.name         = "Ústavný súd Slovenskej republiky"
court.street       = "Hlavná 110"
court.save!

DecreeForm.create name: 'Rozsudok',                  code: 'A'
DecreeForm.create name: 'Uznesenie',                 code: 'N'
DecreeForm.create name: 'Opravné uznesenie',         code: 'R'
DecreeForm.create name: 'Dopĺňací rozsudok',         code: 'D'
DecreeForm.create name: 'Platobný rozkaz',           code: 'P'
DecreeForm.create name: 'Zmenkový platobný rozkaz',  code: 'M'
DecreeForm.create name: 'Európsky platobný rozkaz',  code: 'E'
DecreeForm.create name: 'Šekový platobný rozkaz',    code: 'S'
DecreeForm.create name: 'Rozkaz na plnenie',         code: 'L'
DecreeForm.create name: 'Rozsudok pre zmeškanie',    code: 'K'
DecreeForm.create name: 'Rozsudok pre uznanie',      code: 'U'
DecreeForm.create name: 'Uznesenie bez odôvodnenia', code: 'C'
DecreeForm.create name: 'Osvedčenie',                code: 'B'
DecreeForm.create name: 'Trestný rozkaz',            code: 'T'
