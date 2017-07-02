##
# Docker Drupal Development
#
# Database server container

FROM mysql:5.5

LABEL maintainer="web@stephencox.net"

ADD config/my.cnf /etc/mysql/conf.d/my.cnf

VOLUME /var/lib/mysql

EXPOSE 3306

CMD ["mysqld"]
