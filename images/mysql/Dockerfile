##
# Docker Drupal Development
#
# Database server container

FROM mysql:5.7

LABEL maintainer="web@stephencox.net"

ADD config/docker.cnf /etc/mysql/conf.d/90-docker.cnf
ADD config/overrides.cnf /etc/mysql/conf.d/95-overrides.cnf

VOLUME /var/lib/mysql

EXPOSE 3306

CMD ["mysqld"]
