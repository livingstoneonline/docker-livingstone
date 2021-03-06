FROM livingstoneonline/drupal
MAINTAINER Nigel Banks <nigel.g.banks@gmail.com>

LABEL "License"="GPLv3" \
      "Version"="0.0.1"

RUN apk-install parallel && \
    cleanup

COPY build /build

RUN cd ${DRUPAL_ROOT} && drush make -y --no-core --no-cache /build/site.make && \
    chown -R apache:apache ${DRUPAL_ROOT} && \
    cleanup

ARG BUILD_ENVIRONMENT=prod
RUN if s6-test ${BUILD_ENVIRONMENT} = "dev"; then \
      cd ${DRUPAL_ROOT} && drush make -y --no-core --no-cache /build/dev.make; \
    fi

COPY rootfs /

# Remove insecure code.
RUN rm -fr /var/www/localhost/htdocs/sites/all/libraries/plupload/examples
