# frozen_string_literal: true

# Rows the app and otvorenesudy-api look up by value. Running it again changes nothing.

SOURCES = [
  ['JusticeGovSk', 'Ministerstvo spravodlivosti Slovenskej republiky', 'http://www.justice.gov.sk'],
  ['NrsrSk', 'Národná rada Slovenskej republiky', 'http://www.nrsr.sk'],
  ['PrezidentSk', 'Prezident Slovenskej republiky', 'http://www.prezident.sk'],
  ['SudnaradaGovSk', 'Súdna rada Slovenskej republiky', 'http://www.sudnarada.gov.sk'],
  ['seeds', 'Database seeds file', 'db/seeds.rb']
].freeze

SOURCES.each do |module_name, name, uri|
  Source.find_or_initialize_by(module: module_name).update!(name:, uri:)
end

Municipality.find_or_initialize_by(name: 'Bratislava').update!(zipcode: '814 90')

# Courts closed by the 2023 reform of the court map.
DESTROYED_COURTS = [
  'Okresný súd Bánovce nad Bebravou',
  'Okresný súd Partizánske',
  'Okresný súd Brezno',
  'Okresný súd Čadca',
  'Okresný súd Považská Bystrica',
  'Okresný súd Dolný Kubín',
  'Okresný súd Kežmarok',
  'Okresný súd Nové Mesto nad Váhom',
  'Okresný súd Piešťany',
  'Okresný súd Revúca',
  'Okresný súd Ružomberok',
  'Okresný súd Skalica',
  'Okresný súd Svidník',
  'Okresný súd Topoľčany',
  'Okresný súd Veľký Krtíš',
  'Okresný súd Košice II',
  'Okresný súd Košice-okolie',
  'Okresný súd Bratislava V'
].freeze

Court.where(name: DESTROYED_COURTS).find_each do |court|
  court.update!(destroyed_at: Time.zone.parse('2023-05-31 00:00:00'))
end

DECREE_FORMS = {
  'Čiastočný rozsudok' => 'X',
  'Dopĺňací rozsudok' => 'D',
  'Dopĺňacie uznesenie' => 'R',
  'Európsky platobný rozkaz' => 'E',
  'Medzitýmny rozsudok' => 'X',
  'Opatrenie bez poučenia' => 'X',
  'Opatrenie' => 'X',
  'Opravné uznesenie' => 'R',
  'Osvedčenie' => 'B',
  'Platobný rozkaz' => 'P',
  'Príkaz' => 'X',
  'Rozhodnutie' => 'A',
  'Rozkaz na plnenie' => 'L',
  'Rozsudok bez odôvodnenia' => 'F',
  'Rozsudok pre uznanie' => 'U',
  'Rozsudok pre vzdanie' => 'X',
  'Rozsudok pre zmeškanie' => 'K',
  'Rozsudok' => 'A',
  'Šekový platobný rozkaz' => 'S',
  'Trestný rozkaz' => 'T',
  'Uznesenie bez odôvodnenia' => 'C',
  'Uznesenie' => 'N',
  'Výzva' => 'X',
  'Zmenkový platobný rozkaz' => 'M'
}.freeze

DECREE_FORMS.each do |value, code|
  DecreeForm.find_or_initialize_by(value:).update!(code:)
end

[CourtOfficeType, HearingType, CourtType, Period].each(&:save_values!)
