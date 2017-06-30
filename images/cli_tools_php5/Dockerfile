##
# Docker Drupal Development
#
# Development tools container

FROM ubuntu:16.04

MAINTAINER Stephen Cox "mail@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN locale-gen en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
      build-essential \
      curl \
      git \
      mysql-client \
      openssh-server \
      php5.6-cli \
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
RUN wget http://files.drush.org/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush

# Install npm, gulp and bower
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash - && \
    apt-get install -y \
      nodejs \
      npm && \
    npm install -g \
      bower \
      gulp

# Setup SSH
RUN mkdir /var/run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
