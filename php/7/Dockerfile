# We use Alpine Linux as our base Docker image since it's only 5MB in size so
# allows us to create smaller Docker images
FROM alpine:3.6

# You should modify these variables depending on your application
# * `TZ` should be the timezone you wish to run app to run as
# * `ADDITIONAL_PACKAGES` You can find any additional packages from [the Alpine
#    package explorer](https://pkgs.alpinelinux.org/packages)
# * `PHP_MEMORY_LIMIT` The memory limit of the PHP app
ENV TZ=Asia/Tehran \
    ADDITIONAL_PACKAGES="php7-pdo_pgsql php7-pdo_mysql php7-redis" \
    PHP_MEMORY_LIMIT=128M \
    PHP_UPLOAD_MAX_SILE_SIZE=50M \
    PHP_POST_MAX_SIZE=50M

# Install the required packages. We have included popular PHP packages by
# default but you can add more using the `ADDITIONAL_PACKAGES` variable above.
RUN apk update && \
    apk add tzdata curl bash ca-certificates rsync supervisor nginx \
            php7 php7-fpm php7-common php7-openssl php7-session php7-bcmath \
            php7-dom php7-tokenizer php7-pdo php7-json php7-phar php7-mbstring \
            php7-iconv php7-zlib php7-ctype php7-xml ${ADDITIONAL_PACKAGES} && \
    # Install composer.
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer && \
    # Set the timezone based on the `TZ` variable above
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    # Set the nginx config. We want nginx to run as the default Docker image's
    user so we comment this out in the config.
    sed -i "/user nginx;/c #user nginx;" /etc/nginx/nginx.conf && \
    # Set php.ini config. You can add any extra overrides you wish here.
    sed -i "/date.timezone =/c date.timezone = ${TZ}" \
           /etc/php7/php.ini && \
    sed -i "/memory_limit = /c memory_limit = ${PHP_MEMORY_LIMIT}" \
           /etc/php7/php.ini && \
    sed -i "/upload_max_filesize = /c upload_max_filesize = ${PHP_UPLOAD_MAX_SILE_SIZE}" \
           /etc/php7/php.ini && \
    sed -i "/post_max_size = /c post_max_size = ${PHP_POST_MAX_SIZE}" \
           /etc/php7/php.ini && \
    # Set PHP FPM config. You can add any extra overrides you wish here.
    sed -i "/listen.owner = /c listen.owner = root" \
           /etc/php7/php-fpm.d/www.conf && \
    sed -i "/listen = /c listen = 127.0.0.1:9000" \
           /etc/php7/php-fpm.d/www.conf && \
    sed -i "/;clear_env = /c clear_env = no" \
           /etc/php7/php-fpm.d/www.conf && \
    # Setup any permissions for directories and files we are writing to. We need
    # to ensure these are group-writeable for the default Docker image's user.
    # To do this we need to create those folders, set the group to the root
    # group and add the correct group permissions. For more information see the
    # [OpenShift Origin documentation](https://docs.openshift.org/latest/creating_images/guidelines.html#use-uid).
    mkdir -p /.composer /.config /run/nginx /var/lib/nginx/logs && \
    chgrp -R 0        /.composer /.config /var/log /var/run /var/tmp \
                      /run/nginx /var/lib/nginx && \
    chmod -R g=u,a+rx /.composer /.config /var/log /var/run /var/tmp \
                      /run/nginx /var/lib/nginx && \
    # Ensure the nginx logs are forwarded to stdout and stderr so they appear
    # in the container logs.
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    # Clean up the package cache - This helps reduce the size of the Docker
    # image.
    rm -rf /var/cache/apk/*

# Expose the port we are running nginx on inside the container
EXPOSE 8080
# Set the current directory for the Docker image
WORKDIR /var/www

# Copy the required configuration files into the Docker image. We don't copy the
# application files yet because we want to increase the chances that running
# `composer install` will be cached.
COPY supervisord.conf /
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY composer.json composer.lock ./

# Run composer install
RUN composer install --no-scripts --no-autoloader --prefer-dist --no-dev \
                     --working-dir=/var/www

# Copy the application files. We initially copy them to a temp directory so we
# can update the permissions and then copy them to the target directory. This
# is done as it reduces the size of the Docker image.
COPY . /tmp/app
RUN chgrp -R 0 /tmp/app && \
    chmod -R g=u /tmp/app && \
    cp -a /tmp/app/. /var/www && \
    rm -rf /tmp/app && \
    # Run any install scripts for the app.
    # Laravel users: Don't put `php artisan config:cache` in the Dockerfile as it
    # prevents the app from reading ENV vars at runtime.
    composer dump-autoload --optimize && \
    # Ensure the start script is executable
    chmod +x start.sh

# Specifies the script to run when the container starts.
CMD ["./start.sh"]

# Specifies the default user for the Docker image to run as. For more details
# see the [OpenShift Origin documentation](https://docs.openshift.org/latest/creating_images/guidelines.html#use-uid)
USER 1001
