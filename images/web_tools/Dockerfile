##
# Docker Drupal Development
#
# Web tools container

FROM ubuntu:16.04

LABEL maintainer="web@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Add a docker user
RUN useradd -m -s /bin/bash -G sudo,www-data,adm -p docker docker && \
    printf "\ndocker ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers

# Install packages.
RUN apt-get update && \
    apt-get install -y \
      apache2 \
      curl \
      git \
      libapache2-mod-php7.0 \
      php7.0-mbstring \
      php7.0-mysql \
      php7.0-pgsql && \
    apt-get clean

# Configure Apache
ENV APACHE_RUN_USER docker
ENV APACHE_RUN_GROUP docker
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
COPY config/apache2/web-tools.conf /etc/apache2/sites-available/web-tools.conf
COPY config/apache2/overrides.conf /etc/apache2/conf-available/overrides.conf
RUN a2dissite 000-default.conf && \
    a2ensite web-tools.conf && \
    ln -s /etc/apache2/conf-available/overrides.conf /etc/apache2/conf-enabled/overrides.conf

# Install Adminer
RUN mkdir /var/www/adminer && \
    curl -L https://www.adminer.org/latest.php -o /var/www/adminer/index.php

# Install Pimp My Log
RUN git clone https://github.com/potsky/PimpMyLog.git /var/www/logs && \
    cd /var/www/logs/ && \
    git checkout v1.7.14
COPY config/apache2/config.user.php /var/www/logs/config.user.php
RUN touch '/var/www/logs/inc/test.PLEASE_REMOVE_ME.access_from_172.18.0.1_only.php'

# Add index file
COPY config/apache2/index.html /var/www/index.html

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
