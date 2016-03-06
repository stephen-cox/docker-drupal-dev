FROM ubuntu:14.04

MAINTAINER Stephen Cox "mail@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Install packages.
RUN apt-get update && \
    apt-get install -y \
	    apache2 \
	    build-essential \
	    curl \
	    git \
	    libapache2-mod-php5 \
	    mailutils \
	    mysql-client \
	    openssh-server \
	    php5-cli \
	    php5-mysql \
	    php5-gd \
	    php5-curl \
	    php5-xdebug \
	    ssmtp \
	    supervisor \
	    unzip \
	    wget && \
	apt-get clean

# Add a docker user
RUN useradd -m -s /bin/bash -G sudo -p docker docker && \
    mkdir -p "/home/docker/.ssh" && \
    printf "docker ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/docker
COPY config/docker.ssh.pub /home/docker/.ssh/authorized_keys

# Configure Apache
ENV APACHE_RUN_USER www-data && \
    APACHE_RUN_GROUP www-data && \
    APACHE_LOG_DIR /var/log/apache2 && \
    APACHE_LOCK_DIR /var/lock/apache2 && \
    APACHE_PID_FILE /var/run/apache2.pid
COPY config/apache2/drupal.conf /etc/apache2/sites-available/drupal.conf
RUN usermod -aG docker www-data && \
    a2enmod rewrite && \
    a2dissite 000-default.conf && \
    a2ensite drupal.conf && \
    rm -fr /var/www/*

# Configure PHP
COPY config/php5/local.ini /etc/php5/apache2/conf.d/00-local.ini

# Configure SSMTP
COPY config/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf

# Install Composer
RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === 'fd26ce67e3b237fffd5e5544b45b0d92c41a4afe3e3f778e942e43ce6be197b9cdc7c251dcde6e2a52297ea269370680') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); }" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# Install Drush
RUN wget http://files.drush.org/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush

# Install npm, gulp and bower
RUN curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash - && \
    apt-get install -y nodejs && \
    npm install -g bower gulp

# Setup Supervisor
RUN mkdir /var/run/sshd
COPY config/supervisor/apache.conf /etc/supervisor/conf.d/apache.conf 
COPY config/supervisor/ssh.conf /etc/supervisor/conf.d/ssh.conf

EXPOSE 80 22

CMD /usr/bin/supervisord -n
