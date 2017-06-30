##
# Docker Drupal Development
#
# Drupal web server container

FROM ddd/apache2

MAINTAINER Stephen Cox "mail@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Install packages.
RUN apt-get update && \
    apt-get install -y \
      libapache2-mod-php7.0 \
      php7.0-curl \
      php7.0-gd \
      php7.0-ldap \
      php7.0-mysql \
      php7.0-opcache \
      php7.0-pgsql \
      php7.0-sqlite \
      php7.0-tidy \
      php7.0-xml \
      php7.0-zip \
      php-imagick \
      php-imap \
      php-intl \
      php-json \
      php-mbstring \
      php-mcrypt \
      php-memcache \
      php-redis \
      php-soap \
      php-xdebug && \
    apt-get clean

# Configure PHP
COPY config/php/docker.ini /etc/php/7.0/mods-available/docker.ini
COPY config/php/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
RUN phpenmod imap && \
    phpenmod mcrypt && \
    phpenmod xdebug && \
    ln -s /etc/php/7.0/mods-available/docker.ini /etc/php/7.0/apache2/conf.d/90-docker.ini

EXPOSE 80 443

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
