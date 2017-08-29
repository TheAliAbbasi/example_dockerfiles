#!/bin/bash

php5-fpm --allow-to-run-as-root --fpm-config /etc/php5/fpm/php-fpm.conf &
nginx -g "daemon off;"
