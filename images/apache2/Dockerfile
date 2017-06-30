##
# Docker Drupal Development
#
# Drupal web server container

FROM ubuntu:16.04

MAINTAINER Stephen Cox "mail@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Add a docker user
RUN useradd -m -s /bin/bash -G sudo,www-data -p docker docker && \
    printf "\ndocker ALL=(ALL) NOPASSWD: ALL\n" >> /etc/sudoers

# Install packages.
RUN apt-get update && \
    apt-get install -y \
      apache2 \
      curl \
      imagemagick \
      mailutils \
      rsyslog \
      ssmtp && \
    apt-get clean

# Configure Apache
ENV APACHE_RUN_USER docker
ENV APACHE_RUN_GROUP docker
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
COPY config/apache2/docker.conf /etc/apache2/conf-available/docker.conf
COPY config/apache2/vhost.conf /etc/apache2/sites-available/vhost.conf
COPY config/ssl /etc/apache2/ssl
RUN a2enmod rewrite && \
    a2enmod ssl && \
    a2enmod vhost_alias && \
    a2dissite 000-default.conf && \
    a2ensite vhost.conf && \
    ln -s /etc/apache2/conf-available/docker.conf /etc/apache2/conf-enabled/docker.conf && \
    rm -fr /var/www/*

# Configure SSMTP
COPY config/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf

# Configure rsyslog
COPY config/rsyslog/20-logs.conf /etc/rsyslog.d/20-logs.conf

EXPOSE 80 443

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
