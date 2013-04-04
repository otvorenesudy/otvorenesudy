# Open Courts (Otvorené Súdy in Slovak)

Public data project aimed at creating much more user friendly interface to public data provided by [Departement of Justice](http://justice.gov.sk) in Slovak Republic.

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

### ElasticSearch
Follow the [offical installation guide](https://github.com/elasticsearch/elasticsearch).

### PDF processing
```
sudo apt-get install graphicsmagick
sudo apt-get install tesseract-ocr
```

### Tests
Run tests by `rspec` to check if the setup is complete.
Be sure to add PostgreSQL Trigram extension to the test database `RAILS_ENV=test` and then setup database by running `rake db:setup RAILS_ENV=test`.

## Data
1. Setup database:
```
rake db:setup
```
The `db:setup` task loads schema and seed data. Note that the seed data are essential for the next steps.

2. Crawl the necessary data:
```
rake crawl:courts
rake crawl:judges
```

3. Run Resque workers:
```
rake resque:workers QUEUE=* COUNT=4
```

4. Continue crawling the rest using Resque workers in any order:
```
rake work:hearings:civil
rake work:hearings:criminal
rake work:hearings:special
rake work:decrees
```

## Licence
TODO
