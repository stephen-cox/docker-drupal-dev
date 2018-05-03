##
# Docker Drupal Development
#
# Development tools container

FROM ubuntu:16.04

LABEL maintainer="web@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      curl \
      git \
      mysql-client \
      openssh-server \
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
      php-cli \
      php-imagick \
      php-imap \
      php-intl \
      php-json \
      php-mbstring \
      php-mcrypt \
      php-memcache \
      php-redis \
      php-soap \
      php-xdebug \
      postgresql-client \
      unzip \
      wget && \
    apt-get clean

# Add a docker user
RUN useradd -m -s /bin/bash -G sudo -p docker docker && \
    mkdir -p "/home/docker/.ssh" && \
    printf "\ndocker ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers
COPY config/docker.ssh.pub /home/docker/.ssh/authorized_keys
RUN chown -R docker:docker /home/docker && \
    chmod 755 /home/docker && \
    chmod 700 /home/docker/.ssh && \
    chmod 600 /home/docker/.ssh/authorized_keys

# Install Composer
RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# Install Drush
RUN wget https://github.com/drush-ops/drush/releases/download/8.1.16/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush

# Install npm, gulp and bower
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y \
      nodejs && \
    npm install -g \
      bower \
      gulp

# Setup SSH
RUN mkdir /var/run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
