# Open Courts (Otvorené Súdy in Slovak)

Public data project aimed at creating more readable and usable interface to public data provided by [Departement of Justice](http://justice.gov.sk) in Slovak Republic. 

## Setup
### Requirements
* Ruby version at least 1.9.3
* Rails 3
* PostgreSQL with trigram extension
* Resque & Redis
* ElasticSearch

### Project and Database
```
git clone git://github.com/otvorenesudy/otvorenesudy-dev.git
cd otvorenesudy-dev
bundle install
cp config/database.{yml.example,yml}
```

Open `config/database.yml` and edit database configuration.

### PostgreSQL Trigram extension
```
sudo apt-get install postgresql-contrib
sudo service postgresql restart
cd /usr/share/postgresql/9.1/extension/
RAILS_ENV=development
psql -U postgres -d opencourts_$RAILS_ENV -f pg_trgm--1.0.sql
```

Set `$RAILS_ENV` variable to your environment (development, test), e.g. `RAILS_ENV=development`.
Create database, load schema and seeds by `rake db:setup`.


### ElasticSearch
Follow the [offical installation guide](https://github.com/elasticsearch/elasticsearch).

### PDF processing
```
sudo apt-get install graphicsmagick
sudo apt-get install tesseract-ocr
```

### Tests
Be sure to add PostgreSQL trigram extension to test database `RAILS_ENV=test` and then setup database by running `rake db:setup RAILS_ENV=test`.
Run tests by `rspec` to check if the setup is complete. 

## Data
1. Start crawling the necessary data:
```
rake crawl:courts
rake crawl:judges
```

2. Run Resque workers:
```
rake resque:workers QUEUE=* COUNT=4
```

3. Continue crawling the rest using Resque jobs in any order:
```
rake run:crawlers:hearings:civil
rake run:crawlers:hearings:criminal
rake run:crawlers:hearings:special
rake run:crawlers:decrees
```

## Licence
TODO
