# Open Courts (Otvorené Súdy in Slovak)

Public data project aimed at creating much more user friendly interface to interesting public data provided by [Departement of Justice](http://www.justice.gov.sk) and [The Judical Council](http://www.sudnarada.sk) of the Slovak Republic.

## Setup

### Requirements

* Ruby 2.0
* Rails 3
* PostgreSQL 9.1 with trigram extension
* Redis & Resque
* Elasticsearch 0.9

### Project and Database

```
git clone git://github.com/otvorenesudy/otvorenesudy.git
cd otvorenesudy
git submodule init   # initialize submodule, e.g. otvorenesudy-data
git submodule update # or git submodule foreach git pull origin master
bundle install
cp config/database.{yml.example,yml}
```

Open `config/database.yml` and edit database configuration.
Set `$RAILS_ENV` variable to your environment (development, test) and create the database.

```
RAILS_ENV=development
rake db:create
```

### PostgreSQL Trigram extension

```
sudo apt-get install postgresql-contrib
sudo service postgresql restart
cd /usr/share/postgresql/9.1/extension/
psql -U postgres -d opencourts_$RAILS_ENV -f pg_trgm--1.0.sql
```

Note that you need to set up the Trigram extension for all Rails environments you plan to use separatly.

### Elasticsearch

Follow the [offical installation guide](https://github.com/elasticsearch/elasticsearch).

### PDF processing

```
sudo apt-get install graphicsmagick
sudo apt-get install tesseract-ocr
```

### Tests

Run tests by `rspec` to check if the setup is complete.
Be sure to add PostgreSQL Trigram extension to the test database `RAILS_ENV=test` and then setup database by running `rake db:setup RAILS_ENV=test`.
Tests do not assume any data in the database, since `FactoryGirl` creates sample model instances.

To quicky setup a small database with real production data for development purposes run `rake fixtures:db:setup` command.

## Data

Setup database:

```
rake db:setup
```

The `db:setup` task loads schema and seed data. Note that the seed data are essential for the next steps.

Crawl the necessary data, courts and judges from justice.gov.sk:

```
rake crawl:courts
rake crawl:judges
```

Add court acronyms:

```
rake process:court_acronyms
```

Process known paragraph descriptions:

```
rake process:paragraphs
```

### Hearings and decrees from justice.gov.sk

Start Resque workers:

```
rake resque:workers QUEUE=* COUNT=4
```

Crawl and process hearings and decrees using Resque workers in any order:

```
rake work:hearings:civil
rake work:hearings:criminal
rake work:hearings:special
rake work:decrees
```

### Judge property declarations from sudnarada.gov.sk

Crawl judge property declarations:

```
rake crawl:judge_property_declarations
```

Note that currect support is only for property declarations of 2011 and 2012.

### Partially preprocessed statistical summaries from justice.gov.sk

Court statistical summaries:

```
rake process:court_statistical_summaries:2011
rake process:court_statistical_summaries:2012
```

Judge statistical summaries:

```
rake process:judge_statistical_summaries:2011
rake process:judge_statistical_summaries:2012
```

### Partially preprocessed data from various sources

Court expenses from justice.gov.sk:

```
rake process:court_expenses:2010
rake process:court_expenses:2011
rake process:court_expenses:2012
```

Process judge designations from nrsr.sk and prezident.sk:

```
rake process:judge_designations:nrsr_sk
rake process:judge_designations:prezident_sk
```

## Contributing

1. Fork it
2. Create your feature branch `git checkout -b new-feature`
3. Commit your changes `git commit -am 'Added some feature'`
4. Push to the branch `git push origin new-feature`
5. Create new Pull Request

## License

[Educational Community License 1.0](http://opensource.org/licenses/ecl1.php)
