# Docker Drupal Development

Drupal development environment using Docker Compose

## Included containers

 - Webserver with Apache and PHP 5.6 through mod_php
 - Database with MySQL
 - Adminer for DB access through a UI
 - Mailhog for email debugging
 - Dev tools with SSH access for the latest command line development tools
 - Optionally Solr server

## Installation

Install Docker - https://docs.docker.com/engine/installation/  
Install Docker Compose - https://docs.docker.com/compose/install/

Clone this repo, pull the Docker containers and run them

```
git clone https://github.com/stephen-cox/docker-drupal-dev.git
cd docker-drupal-dev
docker-compose up    
```

## Adding development site

To do

## Development

Rather than pulling the Docker images you can build them yourself:

```
docker build images/apache2/ -t dockerdrupaldev/apache2:latest
docker build images/apache2_php5/ -t dockerdrupaldev/apache2-php5:latest
docker build images/apache2_php7/ -t dockerdrupaldev/apache2-php7:latest
docker build images/cli_tools_php5/ -t dockerdrupaldev/cli-tools-php5:latest
docker build images/cli_tools_php7/ -t dockerdrupaldev/cli-tools-php7:latest
docker build images/mysql/ -t dockerdrupaldev/mysql:latest
docker build images/web_tools/ -t dockerdrupaldev/web-tools:latest
docker build images/varnish/ -t dockerdrupaldev/varnish:latest
```
