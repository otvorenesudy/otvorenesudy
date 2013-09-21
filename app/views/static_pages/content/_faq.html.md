## Často kladené otázky

# O projekte

#### Čo je cieľom projektu? 

Cieľom projektu Otvorené súdy je na základe verejne dostupných dát zvýšiť tlak
na kvalitu slovenského súdnictva. Stránka pomocou týchto dát sprehľadňuje
činnosť súdov a sudcov a umožňuje ich porovnanie.

Dlhodobým cieľom <%= external_link_to "Transparency International Slovensko", 'http://transparency.sk', icon: false %>
je prispieť k vývoju kvalitatívnych aj kvantitatívnych indikátorov, ktoré by
umožňovali merať kvalitu a zmeny kvality v súdnictve na úrovni súdov a sudcov.

#### Čo môžem na portáli robiť?

Stránka poskytuje informácie o činnosti
<%= link_to "súdov", search_courts_path %>,
profily <%= link_to "sudcov", search_judges_path %>,
minulé aj budúce <%= link_to "pojednávania", search_hearings_path %> a
viac ako pol milióna <%= link_to "súdnych rozhodnutí", search_decrees_path %>.

#### Viete mi poskytnúť právne poradenstvo?

Právna poradňa nie je súčasťou tohto projektu. V prípade, že právnu radu
hľadáte, môžete sa obrátiť na
<%= external_link_to "Centrum právnej pomoci", 'http://www.legalaid.sk', icon: false %>.
Úlohou centra je však pomoc materiálne znevýhodneným, ktorí si inú právnu pomoc
dovoliť nemôžu, no s jednoduchými vecami Vám môžu poradiť. Tiež si môžete
priamo vyhľadať advokáta na stránke
<%= external_link_to "Slovenskej advokátskej komory", 'https://www.sak.sk/blox/cms/sk/sak/adv/vyhladanie', icon: false %>,
na ktorého sa obrátite.

#### Kto sú autori projektu? 

Autormi projektu sú
<%= external_link_to "Samuel Molnár", 'https://twitter.com/samuelmolnar', icon: false %> a
<%= external_link_to "Pavol Zbell", 'https://twitter.com/pavolzbell', icon: false %>
(členovia výskumnej skupiny <%= external_link_to "PeWe", 'http://pewe.fiit.stuba.sk', icon: false %> na
<%= external_link_to "Fakulte informatiky a informačných technológií", 'http://fiit.stuba.sk', icon: false %>
<%= external_link_to "Slovenskej technickej univerzity v Bratislave", 'http://stuba.sk', icon: false %>) a
<%= external_link_to "Transparency International Slovensko", 'http://transparency.sk', icon: false %>.

#### Kto to platí?

Projekt Otvorené Súdy vznikol vďaka podpore sekretariátu
<%= external_link_to "Transparency International", 'http://transparency.org', icon: false %>
v Berlíne a projektu <%= external_link_to "Reštart", 'http://restartslovensko.sk', icon: false %>
organizovaného <%= external_link_to "Centrom pre filantropiu", 'http://cpf.sk', icon: false %>.

Za hosting projektu ďakujeme spoločnosti
<%= external_link_to "Petit Press", 'http://petitpress.sk', icon: false %>,
prevádzkovateľovi portálu <%= external_link_to "sme.sk", 'http://sme.sk', icon: false %>.

#### Ako môžem pomôcť?

Používajte stránku, dajte o nej vedieť známym, ktorých by mohla zaujímať.
Sledujte novinky na sociálnych sieťach
<%= external_link_to "Facebook", 'https://facebook.com/otvorenesudy', icon: false %> a
<%= external_link_to "Twitter", 'https://twitter.com/otvorenesudy', icon: false %>,
a ak ste programátor tak určite aj na sieti
<%= external_link_to "GitHub", 'https://github.com/otvorenesudy', icon: false %>.

Ak môžete, prosím, zvážte
<%= external_link_to "finančnú podporu", 'http://transparency.darujme.sk/238/', icon: false %>
projektu.

# O dátach

#### Odkiaľ pochádzajú použité dáta?

Portál využíva výhradne dáta zverejnené alebo sprístupnené
nasledujúcimi verejnými inštitúciami:  

<hr/>

- <%= external_link_to "Ministerstvo spravodlivosti Slovenskej republiky", 'http://www.justice.gov.sk', icon: false %>

  - <%= external_link_to "Súdy", 'http://www.justice.gov.sk/Stranky/Sudy/SudZoznam.aspx', icon: false %>
  - <%= external_link_to "Sudcovia", 'http://www.justice.gov.sk/Stranky/Sudcovia/SudcaZoznam.aspx', icon: false %>
  - <%= external_link_to "Súdne pojednávania", 'http://www.justice.gov.sk/Stranky/Pojednavania/Pojednavania-uvod.aspx', icon: false %>
  - <%= external_link_to "Súdne rozhodnutia", 'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx ', icon: false %>
  - <%= external_link_to "Štatistiky o súdoch", 'http://www.justice.gov.sk/Stranky/Sudy/Statistika-sudy.aspx', icon: false %>
  - <%= external_link_to "Ročné štatistické výkazy o činnosti sudcov", 'http://www.justice.gov.sk/rsvs', icon: false %>
  - <%= external_link_to "Životopisy a motivačné listy sudcov", 'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Zoznam-vyberovych-konani.aspx', icon: false %>

<hr/>

- <%= external_link_to "Súdna rada Slovenskej republiky", 'http://www.sudnarada.gov.sk', icon: false %>

  - <%= external_link_to "Majetkové priznania sudcov", 'http://www.sudnarada.gov.sk/majetkove-priznania-sudcov-slovenskej-republiky/', icon: false %>

<hr/>

- <%= external_link_to "Národná rada Slovenskej republiky", 'http://www.nrsr.sk', icon: false %> a <%= external_link_to "Kancelária prezidenta Slovenskej republiky", 'http://www.prezident.sk', icon: false %>

  - Dátumy menovania sudcov do funkcie

<hr/>

Za vecnú správnosť dát autori nenesú zodpovednosť. Použité dáta boli
normalizované a navzájom prepojené.

Mediálne dáta pochádzajú z článkov na spravodajských portáloch:
sme.sk, tyzden.sk, webnoviny.sk, tvnoviny.sk, pravda.sk, etrend.sk, aktualne.sk.
Odkazy na tieto články sú vyhľadávané automaticky na základe názvu súdu alebo
mena a pôsobiska sudcu. Súdu ani sudcu sa týkať nemusia.

#### Ako často sú dáta aktualizované? 

Za bežnej prevádzky plánujeme aktualizovať dáta o súdnych pojednávaniach denne.
Dáta o súdnych rozhodnutich by sme radi aktualizovali najmenej raz za týždeň.

#### Našiel som chybu, čo mám spraviť?

Napíšte nám, prosím, čo najpresnejší popis chyby a zašlite nám ho e-mailom
na <%= mail_to 'kontakt@otvorenesudy.sk', nil, encode: :hex %>. Ak ste našli
<%= link_to "chybu v dátach", static_page_path(:feedback), icon: false %>
prípadne <%= link_to "bezpečnostnú chybu", static_page_path(:security), icon: false %>,
postupujte podobne.

#### Sú dáta úplné?

Dobrá otázka. Úplné v zmysle vernej, lepšej a použiteľnejšej kópie, by mali
byť informácie o súdoch, sudcoch a súdnych rozhodnutiach.

Informácie o súdnych pojednávaniach by mali byť úplnejšie &ndash; Otvorené
Súdy by mali poskytovať viac dát ako stránka ministerstva spravodlivosti.

#### A čo dátové chyby?

Tie sú náročnejšie na opravu &ndash; dáta mohli byť chybné pred tým ako sme
ich získali, alebo sme niečo pokazili my. Snažíme sa, aby chýb bolo najmenej
a do budúcna plánujeme pracovať na elegantnom riešení opravy chýb.

# O súdoch

#### Nevidím Ústavný súd? Prečo?

Lebo k nemu momentálne nemáme dáta. Ústavný súd zverejňuje informácie o svojej agende samostatne, budeme sa snažiť tieto dáta na stránku získať.

# O sudcoch

#### Naozaj máme vyše 2 000 sudcov?

Nie. Na Slovensku máme približne 1 400 činných sudcov, ich presný aktuálny
počet nevieme povedať &ndash; jednak pre zlé zdrojové dáta, ale aj preto,
že sudcovia môžu mať prerušený výkon funkcie.  

#### Kto sú tí zvyšní? Kto sú VSÚ?

VSÚ sú takzvaní „vyšší súdni úradníci“, ktorí pomáhajú sudcom a môžu vydávať
aj vybrané súdne rozhodnutia. Celkovo ich je na Slovensku vyše 1 000.

Keďže Ministerstvo spravodlivosti nemá zoznam vyšších súdnych úradníkov,
boli identifikovaní ako osoby, ktoré vydali súdne rozhodnutia a zároveň neboli
v zozname sudcov ministerstva spravodlivosti. Následne boli označení ako
„pravdepodobne VSÚ“.

__Sudcovia nemajú uvedené predošlé pôsobisko.__
O tomto vieme. Sudcovia majú uvedené len aktuálne, prípadne posledné pôsobisko.
Ak budeme mať kapacitu, radi vymyslíme spôsob ako mapovať činnosť aj na
predchádzajúcich pôsobiskách.

__Nie všetci sudcovia majú životopis a motivačný list.__
Aj o tomto vieme. Iba sudcovia, ktorí sa zúčastnili výberových konaní po roku
2012, majú tieto zverejnené údaje.

# O rozhodnutiach

#### Aké rozhodnutia sú na stránke?

Na stránke by mali byť zverejnené všetky právoplatné konečné súdne rozhodnutia
vydané po roku 2012, ako aj všetky súvisiace rozhodnutia, ktoré predchádzali
týmto konečným rozhodnutiam. Dáta sú aktualizované z databázy Ministerstva
spravodlivosti v týždenných intervaloch.

Úplne presne vysvetlené v
<%= external_link_to "zákone o súdoch", 'http://www.zakonypreludi.sk/zz/2004-757#p82a', icon: false %>.

#### Neviem nájsť rozhodnutie, ktoré existuje. Prečo?

Može ísť o jeden z nasledujúcich prípadov:

- je tesne po jeho vydaní. Rozhodnutia musia byť zverejnené do 15 pracovných
  dní po nadobudnutí ich právoplatnosti,  

- šlo o rozhodnutie, v ktorom bola vylúčená verejnosť,

- ešte sme ho nestihli stiahnuť a spracovať. Rozhodnutia na našej stránke sú
  aktualizované v najviac týždenných intervaloch,

- niečo sa pokazilo <%= icon_tag :frown %>

#### Prečo je na stránke menej rozhodnutí než na stránkach ministerstva?

Vysvetlením sú najmä technické príčiny, a teda skutočnosť, že niektoré
rozhodnutia nebolo možné stiahnuť ani po opakovaných pokusoch. Niektoré
rozhodnutia zas boli uverejnené viackrát s rovnakým ECLI, resp. niektorým
tento identifikátor chýba, a preto sa v našej databáze nenachádzajú.
