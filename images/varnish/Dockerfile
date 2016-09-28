##
# Docker Drupal Development
#
# Drupal web server container

FROM ubuntu:14.04

MAINTAINER Stephen Cox "mail@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive


# Install packages
RUN apt-get update && \
    apt-get install -y \
        varnish && \
    apt-get clean

# Copy config
COPY config/default.vcl /etc/varnish/default.vcl
COPY config/secret /etc/varnish/secret

EXPOSE 81 6082

CMD ["/usr/sbin/varnishd", "-F", "-a", ":81", "-T", "localhost:6082", "-f", "/etc/varnish/default.vcl", "-S", "/etc/varnish/secret", "-s", "main=malloc,256M"]
