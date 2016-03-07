FROM ubuntu:14.04

MAINTAINER Stephen Cox "mail@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Install packages.
RUN apt-get update && \
    apt-get install -y \
	    apache2 \
	    curl \
	    libapache2-mod-php5 \
	    mailutils \
	    mysql-client \
	    openssh-server \
	    php5-cli \
	    php5-mysql \
	    php5-gd \
	    php5-curl \
	    php5-xdebug \
	    ssmtp && \
	apt-get clean

# Add a docker user
RUN useradd -m -s /bin/bash -G sudo -p docker docker && \
    mkdir -p "/home/docker/.ssh" && \
    printf "docker ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/docker
COPY config/docker.ssh.pub /home/docker/.ssh/authorized_keys

# Configure Apache
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
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

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
