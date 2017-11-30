# Prepare required directories for New Relic installation
RUN mkdir -p /var/log/newrelic /var/run/newrelic && \
    touch /var/log/newrelic/php_agent.log /var/log/newrelic/newrelic-daemon.log && \
    chmod -R g+ws /tmp /var/log/newrelic/ /var/run/newrelic/ && \
    chown -R 1001:0 /tmp /var/log/newrelic/ /var/run/newrelic/ && \

    # Download and install New Relic binary.
    # If you are using a Debian-based image change `linux-musl` to `linux` for *NR_OS_TAG*.
    export NR_OS_TAG="linux-musl" # Use 'linux' for Debian-based images and 'linux-musl' for Alpine-based images.
    export NEWRELIC_VERSION=$(curl -sS https://download.newrelic.com/php_agent/release/ | sed -n 's/.*>\(.*'${NR_OS_TAG}'\).tar.gz<.*/\1/p') && \
    cd /tmp && curl -sS "https://download.newrelic.com/php_agent/release/${NEWRELIC_VERSION}.tar.gz" | gzip -dc | tar xf - && \
    cd "${NEWRELIC_VERSION}" && \
    NR_INSTALL_SILENT=true ./newrelic-install install && \
    rm -f /var/run/newrelic-daemon.pid && \
    rm -f /tmp/.newrelic.sock && \

    # Enviroment variables `NEW_RELIC_LICENSE_KEY` and `NEW_RELIC_APP_NAME` are required when building Docker image,
    # so you must set them in your **BuildConfig** Environments. Change `php7` to `php5` if applicable.
    sed -i \
        -e "s/newrelic.license =.*/newrelic.license = ${NEW_RELIC_LICENSE_KEY}/" \
        -e "s/newrelic.appname =.*/newrelic.appname = ${NEW_RELIC_APP_NAME}/" \
        /etc/php7/conf.d/newrelic.ini
