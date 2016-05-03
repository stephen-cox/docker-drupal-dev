Docker Drupal Development
=========================

Drupal development environment using Docker Compose

Included containers
-------------------

Webserver with Apache and PHP 5.6 through mod_php
Database with MySQL
Adminer for DB access through a UI
Mailcatcher for email debugging
Dev tools with SSH access for the latest command line development tools
Optionally Solr

Installation
------------

Install Docker - https://docs.docker.com/engine/installation/
Install Docker Compose - https://docs.docker.com/compose/install/

Clone this repo, build the containers and then run them

    git clone https://github.com/stephen-cox/docker-drupal-dev.git
    cd docker-drupal-dev
    docker-compose build
    docker-compose up    

Adding development site
-----------------------

To do
