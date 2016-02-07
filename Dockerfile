FROM livingstoneonline/islandora
MAINTAINER Nigel Banks <nigel.g.banks@gmail.com>

RUN curl -L https://github.com/livingstoneonline/docker-livingstone/blob/dev/files.tgz?raw=true | \
    tar -xzf - -C ${DRUPAL_ROOT}/sites/default

COPY build /build
RUN cd ${DRUPAL_ROOT} && drush make -y --no-core --no-cache /build/site.make && \
    rm -fr /var/cache/apk/* \
           /root/.drush/cache/* \
           /root/.cache/* \
           /tmp/* && \
    echo '' > /root/.ash_history

VOLUME ${DRUPAL_ROOT}/sites/default/files

ADD entrypoint /entrypoint/livingstone
ENTRYPOINT ["/entrypoint/livingstone/entrypoint.sh"]
CMD ["/usr/sbin/apachectl", "-DFOREGROUND"]

# Install Union for development, it should not be in stage/prod images.
COPY glibc-2.21-r2.apk /tmp/glibc-2.21-r2.apk
RUN apk --update add curl ca-certificates tar && \
    apk add --allow-untrusted /tmp/glibc-2.21-r2.apk
COPY unison /usr/local/bin/unison
EXPOSE 5000
