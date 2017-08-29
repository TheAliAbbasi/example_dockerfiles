#!/bin/bash

php-fpm7.0 --allow-to-run-as-root --fpm-config /etc/php/7.0/fpm/php-fpm.conf &
nginx -g "daemon off;"
