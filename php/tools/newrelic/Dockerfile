RUN \
  # If you're using a Debian-based image, change `linux-musl` to `linux`.
  export NR_OS_TAG="linux-musl" && \
  # For Alpine-based images, use `/etc/php7` or `/etc/php5/`. For Debian-based images, use `/etc/php/7.0/fpm` or `/etc/php5/fpm`.
  export PHP_PATH="/etc/php7" && \
  # No need to edit this or the following.
  # Setup required directories for New Relic.
  mkdir -p /var/log/newrelic /var/run/newrelic && \
  touch /var/log/newrelic/php_agent.log /var/log/newrelic/newrelic-daemon.log && \
  chmod -R g+ws /tmp /var/log/newrelic/ /var/run/newrelic/ && \
  chown -R 1001:0 /tmp /var/log/newrelic/ /var/run/newrelic/ && \
  # Download and install New Relic binary.
  export NEWRELIC_VERSION=$(curl -sS https://download.newrelic.com/php_agent/release/ | sed -n 's/.*>\(.*'${NR_OS_TAG}'\).tar.gz<.*/\1/p') && \
  cd /tmp && curl -sS "https://download.newrelic.com/php_agent/release/${NEWRELIC_VERSION}.tar.gz" | gzip -dc | tar xf - && \
  cd "${NEWRELIC_VERSION}" && \
  NR_INSTALL_SILENT=true ./newrelic-install install && \
  # `NEW_RELIC_ENABLED`, `NEW_RELIC_LICENSE_KEY` and `NEW_RELIC_APP_NAME` are required at run time,
  # so you must set them in your **Deployment** Environments.
  sed -i \
      -e "s/;newrelic.enabled =.*/newrelic.enabled = \${NEW_RELIC_ENABLED}/" \
      -e "s/newrelic.license =.*/newrelic.license = \${NEW_RELIC_LICENSE_KEY}/" \
      -e "s/newrelic.appname =.*/newrelic.appname = \${NEW_RELIC_APP_NAME}/" \
      -e "s/;newrelic.feature_flag =.*/newrelic.feature_flag = \${NEW_RELIC_FEATURE_FLAG}/" \
      $PHP_PATH/conf.d/newrelic.ini
