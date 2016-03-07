FROM ubuntu:14.04

MAINTAINER Stephen Cox "mail@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Install packages.
RUN apt-get update && \
    apt-get install -y \
	    build-essential \
	    curl \
	    git \
	    openssh-server \
	    mysql-client \
	    php5-cli \
	    php5-mysql \
	    php5-gd \
	    php5-curl \
	    php5-xdebug \
	    unzip \
	    wget && \
	apt-get clean

# Add a docker user
RUN useradd -m -s /bin/bash -G sudo -p docker docker && \
    mkdir -p "/home/docker/.ssh" && \
    printf "docker ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/docker
COPY config/docker.ssh.pub /home/docker/.ssh/authorized_keys
RUN chown -R docker:docker /home/docker && \
    chmod 755 /home/docker && \
    chmod 700 /home/docker/.ssh && \
    chmod 600 /home/docker/.ssh/authorized_keys

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

# Setup SSH
RUN mkdir /var/run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
