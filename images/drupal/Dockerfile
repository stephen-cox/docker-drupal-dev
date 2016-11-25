##
# Docker Drupal Development
#
# Drupal web server container

FROM ubuntu:14.04

MAINTAINER Stephen Cox "mail@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Add a docker user
RUN useradd -m -s /bin/bash -G sudo,www-data -p docker docker && \
    printf "docker ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/docker

# Install packages.
RUN apt-get update && \
    apt-get install -y \
	    apache2 \
	    curl \
        imagemagick \
	    libapache2-mod-php5 \
	    mailutils \
        php5-curl \
        php5-gd \
        php5-imagick \
        php5-imap \
        php5-intl \
        php5-json \
        php5-ldap \
        php5-mcrypt \
        php5-memcache \
        php5-mysql \
        php5-redis \
        php5-sqlite \
        php5-tidy \
        php5-xdebug \
        php5-xhprof \
        php-soap \
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
COPY config/apache2/drupal.conf /etc/apache2/sites-available/drupal.conf
COPY config/ssl /etc/apache2/ssl
RUN a2enmod rewrite && \
    a2enmod ssl && \
    a2enmod vhost_alias && \
    a2dissite 000-default.conf && \
    a2ensite drupal.conf && \
    ln -s /etc/apache2/conf-available/docker.conf /etc/apache2/conf-enabled/docker.conf && \
    rm -fr /var/www/*

# Configure PHP
COPY config/php5/docker.ini /etc/php5/apache2/conf.d/00-docker.ini
COPY config/php5/xdebug.ini /etc/php5/apache2/conf.d/20-xdebug.ini
RUN php5enmod imap

# Configure SSMTP
COPY config/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf

# Configure rsyslog
COPY config/rsyslog/20-logs.conf /etc/rsyslog.d/20-logs.conf

EXPOSE 80 443

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
