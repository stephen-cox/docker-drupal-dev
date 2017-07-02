##
# Docker Drupal Development
#
# Drupal web server container

FROM ddd/apache2

LABEL maintainer="web@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Install packages.
RUN locale-gen en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
      libapache2-mod-php5.6 \
      php5.6-curl \
      php5.6-gd \
      php5.6-imap \
      php5.6-ldap \
      php5.6-mbstring \
      php5.6-mcrypt \
      php5.6-mysql \
      php5.6-opcache \
      php5.6-pgsql \
      php5.6-soap \
      php5.6-sqlite \
      php5.6-tidy \
      php5.6-xml \
      php5.6-zip \
      php5.6-intl \
      php5.6-json \
      php-memcache \
      php-redis \
      php-xdebug && \
    apt-get clean

# Configure PHP
COPY config/php/docker.ini /etc/php/5.6/mods-available/docker.ini
COPY config/php/xdebug.ini /etc/php/5.6/mods-available/xdebug.ini
RUN phpenmod xdebug && \
    ln -s /etc/php/5.6/mods-available/docker.ini /etc/php/5.6/apache2/conf.d/90-docker.ini

EXPOSE 80 443

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
