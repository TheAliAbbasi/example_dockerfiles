# Use Alpine Linux as our base Docker image since it's only 5MB in size so
# allows us to create smaller Docker images.
FROM alpine:3.6

# Modify these variables depending on your application:
# * `TZ` Timezone for the app.
# * `ADDITIONAL_PACKAGES` Find any additional packages from [the Alpine
#    package explorer](https://pkgs.alpinelinux.org/packages).
# * `PHP_MEMORY_LIMIT` Memory limit of the PHP app, 128M is a good default.
ENV TZ=Asia/Tehran \
    ADDITIONAL_PACKAGES="php5-pdo_pgsql php5-pdo_mysql" \
    PHP_MEMORY_LIMIT=128M \
    PHP_UPLOAD_MAX_SILE_SIZE=50M \
    PHP_POST_MAX_SIZE=50M

# Install the required packages. Popular PHP packages have been included by
# default but you can add more using the `ADDITIONAL_PACKAGES` variable above.
RUN apk update && \
    apk add tzdata curl bash ca-certificates rsync supervisor nginx \
            php5 php5-fpm php5-common php5-openssl php5-bcmath \
            php5-dom php5-cli php5-pdo php5-json php5-phar \
            php5-iconv php5-zlib php5-ctype php5-xml ${ADDITIONAL_PACKAGES} && \
    # Ensure the default PHP path uses PHP 5
    ln -sf /usr/bin/php5 /usr/bin/php && \
    # Install composer.
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer && \
    # Set the timezone based on the `TZ` variable above.
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    # Set the nginx config. Nginx should be run as the default Docker image's
    # user so this has to be commented out in the config.
    sed -i "/user nginx;/c #user nginx;" /etc/nginx/nginx.conf && \
    # Set php.ini config. Add any extra overrides here.
    sed -i "/date.timezone =/c date.timezone = ${TZ}" \
           /etc/php5/php.ini && \
    sed -i "/memory_limit = /c memory_limit = ${PHP_MEMORY_LIMIT}" \
           /etc/php5/php.ini && \
    sed -i "/upload_max_filesize = /c upload_max_filesize = ${PHP_UPLOAD_MAX_SILE_SIZE}" \
           /etc/php5/php.ini && \
    sed -i "/post_max_size = /c post_max_size = ${PHP_POST_MAX_SIZE}" \
           /etc/php5/php.ini && \
    # Set PHP FPM config. Add any extra overrides here.
    sed -i "/listen.owner = /c listen.owner = root" \
           /etc/php5/php-fpm.conf && \
    sed -i "/listen = /c listen = 127.0.0.1:9000" \
           /etc/php5/php-fpm.conf && \
    sed -i "/;clear_env = /c clear_env = no" \
           /etc/php5/php-fpm.conf && \
    # Setup permissions for directories and files that will be written to at runtime.
    # These need to be group-writeable for the default Docker image's user.
    # To do this, the folders are created, their group is set to the root
    # group, and the correct group permissions are added.
    mkdir -p /.composer /.config /run/nginx /var/lib/nginx/logs && \
    chgrp -R 0        /.composer /.config /var/log /var/run /var/tmp \
                      /run/nginx /var/lib/nginx && \
    chmod -R g=u,a+rx /.composer /.config /var/log /var/run /var/tmp \
                      /run/nginx /var/lib/nginx && \
    # Forward the nginx logs to STDOUT and STDERR so they appear
    # in the container logs.
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    # Clean up the package cache. This reduces the size of the Docker image.
    rm -rf /var/cache/apk/*


# By default all ports are closed in the container. Here the nginx port is opened.
# Other ports that need to be opened can be added here (only ports above 1024), separated by spaces.
EXPOSE 8080
# Set the current directory for the Docker image.
WORKDIR /var/www

# Copy the required configuration files into the Docker image. Don't copy the
# application files yet as they prevent `composer install` from being cached by
# Docker's layer caching mechanism.
COPY supervisord.conf /
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY composer.json composer.lock ./

# Run composer install.
RUN composer install --no-scripts --no-autoloader --prefer-dist --no-dev \
                     --working-dir=/var/www

# Copy the application files. Initially copy them to a temp directory so their
# permissions can be updated and then copy them to the target directory. This
# reduces the size of the Docker image.
COPY . /tmp/app
RUN chgrp -R 0 /tmp/app && \
    chmod -R g=u /tmp/app && \
    cp -a /tmp/app/. /var/www && \
    rm -rf /tmp/app && \
    # Run any install scripts for the app.
    # Laravel users should not put `php artisan config:cache` in the Dockerfile as it
    # prevents the app from reading environment variables at runtime.
    composer dump-autoload --optimize && \
    # Ensure the start script is executable
    chmod +x start.sh

# Specify the command to run when the container starts.
CMD ["./start.sh"]

# Specify the default user for the Docker image to run as.
USER 1001
