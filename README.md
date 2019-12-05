# Purpose

To be able to find the closest hospital based on a given location and the required
needs of the individual.

## Prerequisites

Ruby 2.6.3
PostgresQL
Rails 6.0.1

## Getting started

### Local Development

```bash
git clone https://github.com/paramagicDev/ems_helper
cd ems_helper
touch .env
echo "PG_HOST=''" >> .env
echo "PG_USER='<USER>'" >> .env
echo "PG_PASSWORD='<PASSWORD>'" >> .env
gem install bundler
bundle install
rails yarn:install

rails server
```

### Using docker-compose

```bash
# Install docker-compose
git clone https://github.com/paramagicDev/ems_helper
cd ems_helper
docker-compose up --build
docker-compose run web rails db:setup
```

Then you can open `localhost:3000` to view the server

### Updating Gems

If you are updating a gem, you cannot simply rebuild the container. Instead,
you must run bundle install on the container.

```bash
docker-compose run web bundle install
docker-compose down
docker-compose up
```

### Rebuilding the container

If you make changes to either to `Dockerfile` or `docker-compose.yml` you must update
the container.

```bash
docker-compose down
docker-compose up --build
```
