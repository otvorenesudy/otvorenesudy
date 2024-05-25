# Open Courts (Otvorené Súdy in Slovak)

[![Build Status](https://travis-ci.org/otvorenesudy/otvorenesudy.svg)](https://travis-ci.org/otvorenesudy/otvorenesudy)
[![View performance data on Skylight](https://badges.skylight.io/status/mINBQqa1duz7.svg)](https://oss.skylight.io/app/applications/mINBQqa1duz7)
[![View performance data on Skylight](https://badges.skylight.io/rpm/mINBQqa1duz7.svg)](https://oss.skylight.io/app/applications/mINBQqa1duz7)
[![View performance data on Skylight](https://badges.skylight.io/typical/mINBQqa1duz7.svg)](https://oss.skylight.io/app/applications/mINBQqa1duz7)
[![View performance data on Skylight](https://badges.skylight.io/problem/mINBQqa1duz7.svg)](https://oss.skylight.io/app/applications/mINBQqa1duz7)

Public data project aimed at creating much more user friendly interface to interesting public data provided by [Department of Justice](http://www.justice.gov.sk) and [The Judicial Council](http://www.sudnarada.sk) of Slovak Republic

## Requirements

* Ruby 2.2
* Rails 3.2
* PostgreSQL 9.1
* Elasticsearch 1.7
* Redis 3.4

### PostgreSQL

Make sure to have `pg_trgm` and `pgvector` extensions installed.

### Elasticsearch

Enable Groovy dynamic scripting  

```
script.engine.groovy.inline.aggs: on
script.engine.groovy.inline.search: on
```

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
```

## Images Generation

Use Ruby 2.6.6 locally and install `gem install svgeez` and `npm install -g svgo@1.3.2`. After that, run `app/assets/images/compile`.

## Data

*Following commands across this section should be executed subsequently in general*

```
rake db:create
rake db:migrate # or rake db:structure:load
rake db:seed
```

Note that the seed data are essential for the next steps

### Courts and judges

See [otvorenesudy-api](https://github.com/otvorenesudy/otvorenesudy-api).

### Hearings and decrees

See [otvorenesudy-api](https://github.com/otvorenesudy/otvorenesudy-api).

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
