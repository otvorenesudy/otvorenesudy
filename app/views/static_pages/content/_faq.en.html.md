#### What is the objective of the project?

The objective is to increase pressure on the quality and efficiency of Slovak judiciary by utilization of open-data. The portal makes activities and performance of judges and courts more comprehensive and allows for comparisons.

A long-term objective of <%= link_to 'Transparency International Slovakia', 'http://transparency.sk' %>
is to contribute to the development of qualitative and quantitative indicators that shall allow measure quality and efficicency and their changes in time in the judiciary at the level of judges, as well as courts.

#### What can I find at the portal?

The webpage offers information about activities
<%= link_to 'of courts', courts_path %>,
profiles of <%= link_to 'judges', judges_path %>,
past and the future <%= link_to 'hearings', hearings_path %>
and a great amount of <%= link_to 'judicial decrees', decrees_path %>.

#### Can you offer me a legal advice?

Advisory office is not a part of the project. In case you are searching for a legal advice you can contact
<%= link_to 'Legal Aid Centre', 'http://www.legalaid.sk' %>.
The Centre is obliged to help those in socially disadvantageous position that cannot afford any other legal help, but they can help you with simple matters. You can also search for an advocate at the webpage of
<%= link_to 'Slovak Bar Association', 'https://www.sak.sk/blox/cms/sk/sak/adv/vyhladanie' %>,
that you can subsequently contact.

#### Who are the authors of the project?

Authors are
<%= link_to 'Samuel Molnár', 'https://twitter.com/samuelmolnar' %> a
<%= link_to 'Pavol Zbell', 'https://twitter.com/pavolzbell' %>
(former members of research group <%= link_to 'PeWe', 'http://pewe.fiit.stuba.sk' %> at
<%= link_to 'Faculty of Informatics and Information Technologies', 'http://fiit.stuba.sk' %> of
<%= link_to 'Slovak University of Technology in Bratislava', 'http://stuba.sk' %>) and<%= link_to 'Transparency International Slovakia', 'http://transparency.sk' %>.

#### Who is it paid by?

The project Open Courts was created thanks to the support of the Secretariat of
<%= link_to 'Transparency International', 'http://transparency.org' %>
in Berlin and the project <%= link_to 'Reštart', 'http://restartslovensko.sk' %>
organized by the<%= link_to 'Centre for Philantropy', 'http://cpf.sk' %>.

For the hosting we are grateful to 
<%= link_to 'Petit Press', 'http://petitpress.sk' %>,
administrator of the portal <%= link_to 'SME.sk', 'http://sme.sk' %>.

#### How can I contribute?

Use the webpage. share it with others that may be interested. Follow the news about the project at social networks
<%= link_to 'Facebook', 'https://facebook.com/otvorenesudy' %> and
<%= link_to 'Twitter', 'https://twitter.com/otvorenesudy' %>,
and if you are an IT developer also on
<%= link_to 'GitHub', 'https://github.com/otvorenesudy' %>.

If you can, please consider
<%= link_to 'financial contribution', donation_url %> to the project.

#### Where do the data come from?

Portal uses only data published or made available by public institutions:  

- <%= link_to 'Ministry of Justice of Slovak Republic', 'http://www.justice.gov.sk' %>
  - <%= link_to 'Courts', 'http://www.justice.gov.sk/Stranky/Sudy/SudZoznam.aspx' %>
  - <%= link_to 'Judges', 'http://www.justice.gov.sk/Stranky/Sudcovia/SudcaZoznam.aspx' %>
  - <%= link_to 'Hearings', 'http://www.justice.gov.sk/Stranky/Pojednavania/Pojednavania-uvod.aspx' %>
  - <%= link_to 'Judicial decrees', 'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx' %>
  - <%= link_to 'Statistics about courts', 'http://www.justice.gov.sk/Stranky/Sudy/Statistika-sudy.aspx' %>
  - <%= link_to 'Annual statistical reports of judges', 'http://www.justice.gov.sk/rsvs' %>
  - <%= link_to 'CVs and Letters of motivation of judges', 'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Zoznam-vyberovych-konani.aspx' %>

- <%= link_to 'Judicial Council of Slovak Republic', 'http://www.sudnarada.gov.sk' %>
  - <%= link_to 'Asset declarations of judges', 'http://www.sudnarada.gov.sk/majetkove-priznania-sudcov-slovenskej-republiky' %>

- <%= link_to 'National Council of Slovak Republic', 'http://www.nrsr.sk' %> and <%= link_to 'The office of President of Slovak Republic', 'http://www.prezident.sk' %>
  - Dates of appointments of judges to their positions

Authors are not responsible for factual accuracy of the data. The used data were normalized and interconnected.

Media data come from articles on news portals:
SME.sk, Tyzden.sk, Webnoviny.sk, TVnoviny.sk, Pravda.sk, TREND.sk, Aktualne.sk.
Hyperlinks to these articles are searched automatically using the name of the court or a judge. They may not inform about any particular court or a judges.

#### How often are the data updated?

At the times of regular operation we plan to update the data about hearings daily. The data about judicial decrees are planned to be updated at least once a week.

#### I found a mistake, what shall I do?

Write us an e-mail describing the mistake as accurately as possible to <%= mail_to 'kontakt@otvorenesudy.sk', nil, encode: :hex %>.
If you found an <%= link_to 'error in the data', static_page_path(:feedback) %>, please follow the same instructions.

#### Are the data complete?

Good question. In terms of reliable, better and more comprehensive copy, the information about courts, judges and judicial decrees shall be complete.

Information about hearings shall be more complete than as provided by the ministry &ndash; Open Courts shall offer more data than the webpage of Ministry of Justice.

#### What about data errors?

These are corrected in a rather more difficult way &ndash; the data may have been defective prior obtaining them, or we may have done something wrong. We attempt to minimalize number of any mistakes and we are working on an elegant way to correct defective data.

#### I do not see the Constitutional Court. Why?

Because we do not have data at the moment. The Constitutional Court publishes its data independently from the rest of the courts, but we will try to obtain these information as well.

#### Do we really have more than 2,000 judges?

No. In Slovakia we have approximately 1,400 active judges. It si difficult to say an accurate number of judges due to defective source data as well as because of the fact that some judges may have temporarily interrupted the exercise of the judgeship.

#### Who is the rest? Who are HCO?

HCO are “higher court officials” who assist judges and are allowed to issue ceartain types of judicial decrees. All in all there is more than 1 000 of them. However, as the Ministry does not hav any list of higher court officials, they were identified as people issuing judicial decrees, and at the same time were not in the list of judges provided by the Ministry of Justice. Consequently they were labelled as “probably HCO”.

_Judges do not have information about their previous occupations in their profiles._
We are aware of that. Judges' profiles include only information about the current, possibly the last occupation. Wll we have the capacity we would like to find the way how to map their activities at previous occupations.

_Not all of the judges' profiles include their CVs and Letters of motivation._
We are aware of that as well. Only judges that applied to a selection procedure after 2012 have these information published.

#### What decrees can be found at the webpage?

All of the lawful decrees issued after 2012 are supposed to be published, including all relevant decrees that preceded these final decrees. Data are updated from the database of the Ministry of Justice weekly.

Detailed explanation can be found in
<%= link_to 'Act on courts', 'http://www.zakonypreludi.sk/zz/2004-757#p82a' %>.

#### I cannot find decrees that has been issued. Why?

One of the following explanations may apply:

- not a sufficient time has passed since the decree has been issued. Decrees must be published in 15 days following the date when they became lawful, 

- It is a decree in a case where the public was excluded from its hearings or part of them,

- we did not manage to download it yet. Decrees are updated weekly,

- something went wrong.

#### Why are there fewer decrees on the portal than on the webpage of the ministry?

It can be usually explained as technical difficulties, hence the fact that some of the decrees cannot be downloaded despite repeated efforts. Some of the decrees were, on the other hand, published more than once with the same ECLI, or some of their identificators is missing and therefore they cannot be found in our database.
