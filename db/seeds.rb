# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

court              = Court.new
court.uri          = "http://portal.concourt.sk"
court.type         = CourtType.create value: "Ústavný"  
court.municipality = Municipality.create name: "Košice", zipcode: "042 65"
court.name         = "Ústavný súd Slovenskej republiky"
court.street       = "Hlavná 110"
court.save!

court              = Court.new
court.uri          = "http://www.nsud.sk" 
court.type         = CourtType.create value: "Najvyšší"  
court.municipality = Municipality.create name: "Bratislava", zipcode: "814 90"
court.name         = "Najvyšší súd Slovenskej republiky"
court.street       = "Župné námestie 13"
court.save!

DecreeForm.create value: 'Rozsudok',                  code: 'A'
DecreeForm.create value: 'Uznesenie',                 code: 'N'
DecreeForm.create value: 'Opravné uznesenie',         code: 'R'
DecreeForm.create value: 'Dopĺňací rozsudok',         code: 'D'
DecreeForm.create value: 'Platobný rozkaz',           code: 'P'
DecreeForm.create value: 'Zmenkový platobný rozkaz',  code: 'M'
DecreeForm.create value: 'Európsky platobný rozkaz',  code: 'E'
DecreeForm.create value: 'Šekový platobný rozkaz',    code: 'S'
DecreeForm.create value: 'Rozkaz na plnenie',         code: 'L'
DecreeForm.create value: 'Rozsudok pre zmeškanie',    code: 'K'
DecreeForm.create value: 'Rozsudok pre uznanie',      code: 'U'
DecreeForm.create value: 'Uznesenie bez odôvodnenia', code: 'C'
DecreeForm.create value: 'Osvedčenie',                code: 'B'
DecreeForm.create value: 'Trestný rozkaz',            code: 'T'
