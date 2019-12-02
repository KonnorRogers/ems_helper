# Purpose

To be able to find the closest hospital based on a given location and the required
needs of the individual.

## Prerequisites

Ruby 2.6.3
PostgresQL
Rails 6.0.1

## Getting started

```bash
git clone https://github.com/paramagicDev/ems_helper
cd ems_helper
touch .env
echo "PG_USER='USER'" >> .env
echo "PG_PASSWORD='PASSWORD'" >> .env
gem install bundler
bundle install
rails yarn:install

rails server
```
