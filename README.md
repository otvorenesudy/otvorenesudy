# Open Courts (Otvorené Súdy in Slovak)

[![Build Status](https://travis-ci.org/otvorenesudy/otvorenesudy.svg?branch=beta)](https://travis-ci.org/otvorenesudy/otvorenesudy)

Public data project aimed at creating much more user friendly interface to interesting public data provided by [Departement of Justice](http://www.justice.gov.sk) and [The Judical Council](http://www.sudnarada.sk) of Slovak Republic

## Requirements

* Ruby 2.2
* Rails 3.2
* PostgreSQL 9.1 with trigram extension
* Elasticsearch 1.7
* Redis 3.4

### PostgreSQL Trigram Extension

```
sudo apt-get install postgresql-contrib -y
sudo service postgresql restart
cd /usr/share/postgresql/9.1/extension/
RAILS_ENV=development
psql -U postgres -d opencourts_$RAILS_ENV -f pg_trgm--1.0.sql
```

Note that you need to set up the Trigram extension for all Rails environments you plan to use

## Installation

```
git clone --recursive git://github.com/otvorenesudy/otvorenesudy.git
cd otvorenesudy
bundle install
```

## Configuration

```
cp config/configuration.{yml.example,yml}
cp config/database.{yml.example,yml}
cp config/newrelic.{yml.example,yml}
```

## Data

*Following commands across this section should be executed subsequently in general*

```
rake db:create
rake db:seed
```

Note that the seed data are essential for the next steps

### Courts and judges

Crawl courts and judges from justice.gov.sk:

```
rake crawl:courts
rake crawl:judges
```

Process court acronyms from other source:

```
rake process:court_acronyms
```

Process paragraph descriptions from other source:

```
rake process:paragraphs
```

### Hearings and decrees

Crawl and process hearings and decrees from justice.gov.sk:

```
rake crawl:hearings:civil
rake crawl:hearings:criminal
rake crawl:hearings:special
rake crawl:decrees
```

Note to see `rake work` tasks to crawl via background jobs

### Judge selection procedures

Crawl judge selection procedures from justice.gov.sk:

```
rake crawl:selection_procedures
```

### Judge property declarations

*Judge property declarations processing currently fails as sudnarada.gov.sk switched from semi-structured (HTML tables) to unstructured (PDF document) publishing* 

Crawl judge property declarations from sudnarada.gov.sk:

```
rake crawl:judge_property_declarations
```

Note that current support is only for property declarations of 2011 and 2012

### Partially preprocessed statistical summaries

Process court statistical summaries from justice.gov.sk:

```
rake process:court_statistical_summaries:2011
rake process:court_statistical_summaries:2012
```

Process judge statistical summaries from justice.gov.sk:

```
rake process:judge_statistical_summaries:2011
rake process:judge_statistical_summaries:2012
```

### Partially preprocessed data from various sources

Process court expenses from justice.gov.sk:

```
rake process:court_expenses:2010
rake process:court_expenses:2011
rake process:court_expenses:2012
rake process:court_expenses:2013
```

Process judge designations from nrsr.sk and prezident.sk:

```
rake process:judge_designations:nrsr_sk
rake process:judge_designations:prezident_sk
```

## Testing

Run specs with `bundle exec rspec`

## Contributing

1. Fork it
2. Create your feature branch `git checkout -b new-feature`
3. Commit your changes `git commit -am 'Add some feature'`
4. Push to the branch `git push origin new-feature`
5. Create new Pull Request

## License

[Educational Community License 1.0](http://opensource.org/licenses/ecl1.php)
