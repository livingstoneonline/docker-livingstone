FROM livingstoneonline/islandora
MAINTAINER Nigel Banks <nigel.g.banks@gmail.com>

ADD files.tar.bz2 ${DRUPAL_ROOT}/sites/default

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
RUN curl -L http://unison-binaries.inria.fr/files/2011.01.28-Esup-unison-2.40.61-linux-x86_64-text-static.tar.gz | \
    tar -xzf - -C /usr/local/bin && \
    mv /usr/local/bin/unison-2.40.61-linux-x86_64-text-static /usr/local/bin/unison
EXPOSE 5000
