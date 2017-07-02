##
# Docker Drupal Development
#
# Varnish image

FROM ubuntu:16.04

LABEL maintainer="web@stephencox.net"
ENV DEBIAN_FRONTEND noninteractive

# Install Varnish
RUN apt-get update && \
    apt-get install -y \
      varnish && \
    apt-get clean

ENV VCL_CONFIG    /etc/varnish/default.vcl
ENV SECRET        /etc/varnish/secret
ENV CACHE_SIZE    256m

EXPOSE 80 6082

CMD /usr/sbin/varnishd -F -a :80 -T :6082 -f ${VCL_CONFIG} -S ${SECRET} -s malloc,${CACHE_SIZE}
