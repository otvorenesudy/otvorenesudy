require 'csv'

map = {
  "JUDr. Marian Tengely": {
    "name": "JUDr. Marián Tengely",
    "id": 1310
  },
  "JUDr. Radka Laceková": {
    "name": "JUDr. Radka Laceková",
    "id": 3347
  },
  "JUDr. Zoltán Orlai": {
    "name": "JUDr. Zoltán Orlai",
    "id": 1535
  },
  "JUDr. Ingrid Kišacová, PhD.": {
    "name": "JUDr. Ingrid Kišacová, PhD.",
    "id": 2548
  },
  "JUDr. Ľuboš Murgaš": {
    "name": "JUDr. Ľuboš Murgaš",
    "id": 2667
  },
  "JUDr. Dagmar Valocká": {
    "name": "JUDr. Dagmar Valocká",
    "id": 1386
  },
  "JUDr. Ivana Michalíková": {
    "name": "JUDr. Ivana Michalíková",
    "id": 3371
  },
  "JUDr. Ondrej Melišek": {
    "name": "JUDr. Ondrej Melišek",
    "id": 1932
  },
  "Mgr. Božena Csibrányiová": {
    "name": "Mgr. Božena Csibrányiová",
    "id": 167
  },
  "Mgr. Pavol Macháč": {
    "name": "Mgr. Pavol Macháč",
    "id": 2338
  },
  "JUDr. Eva Benčová": {
    "name": "JUDr. Eva Benčová",
    "id": 73
  },
  "JUDr. Lenka Saloková": {
    "name": "JUDr. Lenka Saloková",
    "id": 1103
  },
  "JUDr. Zuzana Slušná": {
    "name": "JUDr. Zuzana Slušná",
    "id": 1887
  },
  "JUDr. Milan Majerník, PhD.": {
    "name": "JUDr. Milan Majerník, PhD.",
    "id": 3344
  },
  "Mgr. Miriam Manová": {
    "name": "Mgr. Miriam Manová",
    "id": 774
  },
  "JUDr. Jana Tomášová": {
    "name": "JUDr. Jana Tomášová",
    "id": 1851
  },
  "Mgr. Ľubomíra Podmaníková": {
    "name": "Mgr. Ľubomíra Podmaníková",
    "id": 1860
  },
  "JUDr. Ladislav Réves": {
    "name": "JUDr. Ladislav Réves",
    "id": 3375
  },
  "JUDr. Michaela Buceková PhD.": {
    "name": nil,
    "id": 3404
  },
  "JUDr. Jozef Šulek": {
    "name": "JUDr. Jozef Šulek",
    "id": 3376
  },
  "Mgr. Ing. Judita Gabonaiová Hrenčuková": {
    "name": "Mgr. Ing. Judita Gabonaiová Hrenčuková",
    "id": 2666
  },
  "JUDr. Dušan Szabó": {
    "name": "JUDr. Dušan Szabó",
    "id": 3352
  },
  "JUDr. Robert Šorl, PhD.": {
    "name": "JUDr. Robert Šorl, PhD.",
    "id": 1262
  },
  "Mgr. Katarína Škrovanová": {
    "name": "Mgr. Katarína Škrovanová",
    "id": 1249
  },
  "JUDr. Denisa Novotná Mlinárcsiková": {
    "name": "JUDr. Denisa Novotná Mlinárcsiková",
    "id": 921
  },
  "Mgr. Anna Miháliková": {
    "name": "Mgr. Anna Miháliková",
    "id": 833
  },
  "Mgr. Jarmila Bíliková": {
    "name": "Mgr. Jarmila Bíliková",
    "id": 96
  },
  "JUDr. Marián Dunčko": {
    "name": "JUDr. Marián Dunčko",
    "id": 3349
  },
  "Mgr. Michal Novotný": {
    "name": "Mgr. Michal Novotný",
    "id": 2579
  },
  "Mgr. Michal Pollák": {
    "name": "Mgr. Michal Pollák",
    "id": 3350
  },
  "Mgr. Silvia Lesňáková": {
    "name": "Mgr. Silvia Lesňáková",
    "id": 3203
  },
  "JUDr. Erik Tomus": {
    "name": "JUDr. Erik Tomus",
    "id": 2896
  },
  "JUDr. Hana Posluchová": {
    "name": "JUDr. Hana Posluchová",
    "id": 1020
  },
  "JUDr. Miroslava Korbašová": {
    "name": "JUDr. Miroslava Korbašová",
    "id": 2550
  },
  "JUDr. Tatiana Sabadošová": {
    "name": "JUDr. Tatiana Sabadošová",
    "id": 1097
  },
  "JUDr. Viera Malinowska": {
    "name": "JUDr. Viera Malinowská",
    "id": 2555
  },
  "JUDr. Zuzana Kotríková": {
    "name": "JUDr. Zuzana Kotríková",
    "id": 2551
  },
  "JUDr. Bc. Viktor Marko": {
    "name": "JUDr. Bc. Viktor Marko",
    "id": 778
  },
  "JUDr. Michaela Kotusová Hucová": {
    "name": "JUDr. Michaela Kotusová Hucová",
    "id": 2552
  },
  "JUDr. Natália Štrkolcová": {
    "name": "JUDr. Natália Štrkolcová",
    "id": 3070
  },
  "Mgr. Zuzana Gašpirová": {
    "name": "Mgr. Zuzana Gašpírová",
    "id": 2577
  },
  "JUDr. Mária Szabóová": {
    "name": "JUDr. Mária Szabóová",
    "id": 3209
  },
  "JUDr. Lenka Augustínová": {
    "name": "JUDr. Lenka Augustínová",
    "id": 3214
  },
  "JUDr. Miroslava Šibíková": {
    "name": "JUDr. Miroslava Šibíková",
    "id": 3416
  },
  "JUDr. Monika Vozárová": {
    "name": "JUDr. Monika Vozárová",
    "id": 3357
  },
  "JUDr. Renáta Krajčiová": {
    "name": nil,
    "id": 635
  },
  "JUDr. Lenka Bowker": {
    "name": "JUDr. Lenka Bowker",
    "id": 3055
  },
  "JUDr. Miroslav Šedivec": {
    "name": "JUDr. Miroslav Šedivec",
    "id": 2566
  },
  "Mgr. Alena Jančulová": {
    "name": "Mgr. Alena Jančulová",
    "id": 495
  },
  "Mgr. Radoslav Smatana, PhD.": {
    "name": "Mgr. Radoslav Smatana, PhD.",
    "id": 2580
  },
  "JUDr. Lucia Tóth": {
    "name": "JUDr. Lucia Tóth",
    "id": 3430
  },
  "JUDr. Oliver Kolenčík": {
    "name": "JUDr. Oliver Kolenčík",
    "id": 2418
  },
  "JUDr. Alžbeta Marková": {
    "name": "JUDr. Alžbeta Marková",
    "id": 779
  },
  "JUDr. Monika Kráľová": {
    "name": "JUDr. Monika Kráľová",
    "id": 2578
  },
  "JUDr. Andrej Radomský": {
    "name": "JUDr. Andrej Radomský",
    "id": 2065
  },
  "JUDr. Denisa Cviková": {
    "name": "JUDr. Denisa Cviková",
    "id": 169
  },
  "JUDr. Denisa Šaligová": {
    "name": "JUDr. Denisa Šaligová",
    "id": 1220
  },
  "JUDr. Jana Zuzan": {
    "name": "JUDr. Jana Zuzan",
    "id": 3196
  },
  "JUDr. Zuzana Bartalská": {
    "name": "JUDr. Zuzana Bartalská",
    "id": 54
  },
  "JUDr. Marianna Hirková": {
    "name": "JUDr. Marianna Hirková",
    "id": 3390
  },
  "JUDr. Peter Kalata": {
    "name": "JUDr. Peter Kalata",
    "id": 3211
  },
  "Mgr. Ivana Fekete": {
    "name": "Mgr. Ivana Fekete",
    "id": 276
  },
  "JUDr. Nadežda Wallnerová": {
    "name": "JUDr. Nadežda Wallnerová",
    "id": 1446
  },
  "Mgr. Peter Straka": {
    "name": "Mgr. Peter Straka",
    "id": 1183
  },
  "JUDr. Dušan Špirek": {
    "name": "JUDr. Dušan Špirek",
    "id": 2567
  },
  "JUDr. Milan Husťák": {
    "name": "JUDr. Milan Husťák",
    "id": 450
  },
  "JUDr. Michal Drimák": {
    "name": "JUDr. Michal Drimák, PhD.",
    "id": 3367
  },
  "JUDr. Imrich Hlavička": {
    "name": "JUDr. Imrich Hlavička",
    "id": 1706
  },
  "JUDr. Ing. Erika Trtalová": {
    "name": "JUDr. Ing. Erika Trtalová",
    "id": 1348
  },
  "JUDr. Lenka Saksunová": {
    "name": "JUDr. Lenka Saksunová",
    "id": 3372
  },
  "Mgr. Janka Benkovičová": {
    "name": nil,
    "id": 79
  },
  "Mgr. Silvia Tisová": {
    "name": "Mgr. Silvia Tisová",
    "id": 1314
  },
  "JUDr. Miriam Oswaldová": {
    "name": "JUDr. Miriam Oswaldová",
    "id": 943
  },
  "Mgr. Martin Bauer": {
    "name": "Mgr. Martin Bauer",
    "id": 3345
  },
  "JUDr. Lucia Chrapková": {
    "name": "JUDr. Lucia Chrapková, PhD.",
    "id": 463
  },
  "Mgr. Boris Vittek": {
    "name": "Mgr. Boris Vittek",
    "id": 1682
  },
  "JUDr. Katarína Gašparová": {
    "name": "JUDr. Katarína Gašparová",
    "id": 323
  },
  "JUDr. Andrea Vojteková Fejérová": {
    "name": "JUDr. Andrea Vojteková Fejérová",
    "id": 1431
  },
  "JUDr. Zdenka Tomašková": {
    "name": "JUDr. Zdenka Tomašková",
    "id": 1323
  },
  "Mgr. Gabriela Repková": {
    "name": "Mgr. Gabriela Repková",
    "id": 2562
  },
  "Mgr. Ing. Ladislav Burda": {
    "name": "Mgr. Ing. Ladislav Burda",
    "id": 3215
  },
  "Mgr. Monika Czafiková": {
    "name": "Mgr. Monika Czafiková",
    "id": 1593
  },
  "JUDr. Gabriela Tomvčovčíková Šandalová": {
    "name": nil,
    "id": 1327
  },
  "JUDr. Dana Farkášová": {
    "name": "JUDr. Dana Farkašová",
    "id": 268
  },
  "JUDr. Martina Líšková": {
    "name": "JUDr. Martina Líšková",
    "id": 2554
  },
  "JUDr. Zuzana Hlistová": {
    "name": "JUDr. Zuzana Hlistová",
    "id": 3207
  },
  "Mgr. Anna Holeščáková": {
    "name": "Mgr. Anna Holeščáková",
    "id": 1786
  },
  "JUDr. Slávka Garančovská": {
    "name": "JUDr. Slávka Garančovská",
    "id": 320
  },
  "JUDr. Štefan Tomašovský": {
    "name": "JUDr. Štefan Tomašovský",
    "id": 1325
  },
  "Mgr. Lýdia Stehurová": {
    "name": "Mgr. Lýdia Stehurová",
    "id": 1667
  },
  "JUDr. Magdaléna Bošková": {
    "name": nil,
    "id": 3389
  },
  "JUDr. Miriam Repáková": {
    "name": "JUDr. Miriam Repáková",
    "id": 1070
  }
}

i2017 = CSV.read(Rails.root.join('data', 'judge-statistical-indicators-2017.csv'), col_sep: ',', headers: true)
i2015 = CSV.read(Rails.root.join('data', 'judge-statistical-indicators-2015.csv'), col_sep: ',', headers: true)

i2017.each do |e|
  row = i2015.find { |i| i[2] == e[2] }

  e[1] = row ? row[1] : map[e[2].to_sym][:id]
end

CSV.open('tmp/judge-statistical-indicators-2017.csv', 'w') do |csv|
  csv << i2017.headers
  i2017.each do |row|
    csv << row
  end
end

i2017 = CSV.read(Rails.root.join('data', 'judge-numerical-indicators-2017.csv'), col_sep: ',', headers: true)
i2015 = CSV.read(Rails.root.join('data', 'judge-numerical-indicators-2015.csv'), col_sep: ',', headers: true)

i2017.each do |e|
  row = i2015.find { |i| i[2] == e[2] }

  e[1] = row ? row[1] : map[e[2].to_sym][:id]
end

CSV.open('tmp/judge-numerical-indicators-2017.csv', 'w') do |csv|
  csv << i2017.headers
  i2017.each do |row|
    csv << row
  end
end
