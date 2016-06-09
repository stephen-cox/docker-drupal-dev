##
# Docker Drupal Development
#
# Syslog and Pimp my logs container

FROM ubuntu:14.04

MAINTAINER Stephen Cox "mail@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Add a docker user
RUN useradd -m -s /bin/bash -G sudo,www-data,adm -p docker docker && \
    printf "docker ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/docker

# Install packages.
RUN apt-get update && \
    apt-get install -y \
        apache2 \
        curl \
        git \
        libapache2-mod-php5 \
        rsyslog \
        supervisor && \
    apt-get clean

# Configure Apache
RUN usermod -aG adm www-data && \
    rm -fr /var/www/html && \
    git clone https://github.com/potsky/PimpMyLog.git /var/www/html
COPY config/apache2/config.user.php /var/www/html/config.user.php

# Configure rsyslog
COPY config/rsyslog/rsyslog.conf /etc/rsyslog.conf
COPY config/rsyslog/10-server.conf /etc/rsyslog.d/10-server.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 514/udp

CMD ["/usr/bin/supervisord"]
