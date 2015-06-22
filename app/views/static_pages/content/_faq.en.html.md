## Frequently asked questions

# About

#### What is the objective of the project?

The objective is to increase pressure on the quality and efficiency of the Slovak judiciary by utilization of open-data. The portal makes activities and performance of judges and courts more comprehensive and allows for comparisons. A long-term objective of <%= external_link_to "Transparency International Slovakia", 'http://transparency.sk' %>
is to contribute to the development of qualitative and quantitative indicators that shall allow measure quality and efficicency and their changes in time in the judiciary at the level of judges, as well as courts.

#### What can I find at the portal?

The webpage offers information about activities
<%= link_to "of courts", search_courts_path %>,
profiles of <%= link_to "judges", search_judges_path %>,
past and the future <%= link_to "hearings", search_hearings_path %> and more than a million <%= link_to "judicial decisions", search_decrees_path %>.

#### Can you offer me a legal advice?
Advisory office is not a part of the project. In case you are searching for a legal advice you can contact
<%= external_link_to "Legal Aid Centre", 'http://www.legalaid.sk' %>.
The Centre is obliged to help those in socially disadvantageous position that cannot afford any other legal help, but they can help you with simple matters. You can also search for an advocate at the webpage of
<%= external_link_to "Slovak Bar Association", 'https://www.sak.sk/blox/cms/sk/sak/adv/vyhladanie' %>,
that you can subsequently contact.

#### Who are the authors of the project?
Authors are
<%= external_link_to "Samuel Molnár", 'https://twitter.com/samuelmolnar' %> a
<%= external_link_to "Pavol Zbell", 'https://twitter.com/pavolzbell' %>
(members of the Research group <%= external_link_to "PeWe", 'http://pewe.fiit.stuba.sk' %> na
<%= external_link_to "at the Faculty of Informatics and Information Technologies", 'http://fiit.stuba.sk' %>
<%= external_link_to "of the Slovak University of Technology in Bratislava", 'http://stuba.sk' %>) and<%= external_link_to "Transparency International Slovakia", 'http://transparency.sk' %>.

#### Who is it paid by?
The project Open Courts was created thanks to the support of the Secretariat of
<%= external_link_to "Transparency International", 'http://transparency.org' %>
in Berlin and the project <%= external_link_to "Reštart", 'http://restartslovensko.sk' %>
organized by the<%= external_link_to "Centre for Philantropy", 'http://cpf.sk' %>.For the hosting we are grateful to 
<%= external_link_to "Petit Press", 'http://petitpress.sk' %>,
administrator of the portal <%= external_link_to "sme.sk", 'http://sme.sk' %>.

#### How can I contribute?
Use the webpage. share it with others that may be interested. Follow the news about the project at social networks
<%= external_link_to "Facebook", 'https://facebook.com/otvorenesudy' %> and
<%= external_link_to "Twitter", 'https://twitter.com/otvorenesudy' %>,
and if you are an IT developer also on
<%= external_link_to "GitHub", 'https://github.com/otvorenesudy' %>.
If you can, please consider
<%= external_link_to "financial contribution", 'http://transparency.darujme.sk/238/' %> to the project.

# Data

#### Where do the data come from?

Portal uses only data published or made available by public institutions:  

<hr/>

- <%= external_link_to "Ministry of Justice of the SLovak Republic", 'http://www.justice.gov.sk' %>

  - <%= external_link_to "Courts", 'http://www.justice.gov.sk/Stranky/Sudy/SudZoznam.aspx' %>
  - <%= external_link_to "Judges", 'http://www.justice.gov.sk/Stranky/Sudcovia/SudcaZoznam.aspx' %>
  - <%= external_link_to "Hearings", 'http://www.justice.gov.sk/Stranky/Pojednavania/Pojednavania-uvod.aspx' %>
  - <%= external_link_to "Judicial decisions", 'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx' %>
  - <%= external_link_to "Statistics about courts", 'http://www.justice.gov.sk/Stranky/Sudy/Statistika-sudy.aspx' %>
  - <%= external_link_to "Annual statistical reports of judges", 'http://www.justice.gov.sk/rsvs' %>
  - <%= external_link_to "CVs and Letters of motivation of judges", 'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Zoznam-vyberovych-konani.aspx' %>

<hr/>

- <%= external_link_to "Judicial Council of the Slovak Republic", 'http://www.sudnarada.gov.sk' %>

  - <%= external_link_to "Asset declarations of judges", 'http://www.sudnarada.gov.sk/majetkove-priznania-sudcov-slovenskej-republiky/' %>

<hr/>

- <%= external_link_to "National Council of the Slovak Republic", 'http://www.nrsr.sk' %> a <%= external_link_to "The office of the President of the Slovak Republic", 'http://www.prezident.sk' %>

  - Dates of appointments of judges to their positions

<hr/>Authors are not responsible for factual accuracy of the data. The used data were normalized and interconnected. Media data come from articles on news portals:
sme.sk, tyzden.sk, webnoviny.sk, tvnoviny.sk, pravda.sk, etrend.sk, aktualne.sk.
Hyperlinks to these articles are searched automatically using the name of the court or a judge. They may not inform about any particular court or a judges.

#### How often are the data updated?

At the times of regular operation we plan to update the data about hearings daily. The data about judicial decisions are planned to be updated at least once a week.

#### I found a mistake, what shall I do?

Write us an email describing the mistake as accurately as possible to <%= mail_to 'kontakt@otvorenesudy.sk', nil, encode: :hex %>. If you found a
<%= link_to "error in the data", static_page_path(:feedback) %>possibly <%= link_to "security risk", static_page_path(:security) %>,please follow the same instructions.

#### Are the data complete?

Good question. In terms of reliable, better and more comprehensive copy, the information about courts, judges and judicial decisions shall be complete. Information about hearings shall be more complete than as provided by the Ministry. &ndash; Open Courts shall offer more data than the webpage of Ministry of Justice.

#### What about data errors?

These are corrected in a rather more ddifficult way &ndash; the data may have been defective prior obtaining them, or we may have done something wrong. We attempt to minimalize number of any mistakes and we are working on an elegant way to correct defective data.

# About courts

#### I do not see the Constitutional Court. Why?

Because we do not have data at the moment. The Constitutional Court publishes its data independently from the rest of the courts, but we will try to obtain these information as well.

# About judges

#### Do we really have more than 2 000 judges?

No. In Slovakia we have approximately 1 400 active judges. It si difficult to say an accurate number of judges due to defective source data as well as because of the fact that some judges may have temporarily interrupted the exercise of the judgeship.

#### Who is the rest? Who are HCO?

HCO are "higher court officials" who assist judges and are allowed to issue ceartain types of judicial decisions. All in all there is more than 1 000 of them. However, as the Ministry does not hav any list of higher court officials, they were identified as people issuing judicial decisions, and at the same time were not in the list of judges provided by the Ministry of Justice. Consequently they were labelled as "probably HCO".

__Judges do not have information about their previous occupations in their profiles.__
We are aware of that. Judges' profiles include only information about the current, possibly the last occupation. Wll we have the capacity we would like to find the way how to map their activities at previous occupations.
__Not all of the judges' profiles include their CVs and Letters of motivation.__
We are aware of that as well. Only judges that applied to a selection procedure after 2012 have these information published.

# About judicial decisions

#### What decisions can be found at the webpage?

All of the lawful decisions issued after 2012 are supposed to be published, including all relevant decisions that preceded these final decisions. Data are updated from the database of the Ministry of Justice weekly. Detailed explanation can be found in
<%= external_link_to "Act on courts", 'http://www.zakonypreludi.sk/zz/2004-757#p82a' %>.

#### I cannot find decisions that has been issued. Why?

One of the following explanations may apply: - not a sufficient time has passed since the decision has been issued. Decisions must be published in 15 days following the date when they became lawful. 

- It is a decision in a case where the public was excluded from its hearings or part of them,

- we did not manage to download it yet. Decisions are updated weekly,

- something went wrong <%= icon_tag :frown %>

#### Why are there fewer decisions on the portal than on the webpage of the Ministry?

It can be usually explained as technical difficulties, hence the fact that some of the decisions cannot be downloaded despite repeated efforts. Some of the decisions were, on the other hand, published more than once with the same ECLI, or some of their identificators is missing and therefore they cannot be found in our database.