#!/bin/bash

if [ "$ENTRYPOINT" = "workers" ]; then
  echo Starting workers
  php artisan queue:work --tries=3

elif [ "$ENTRYPOINT" = "schedule_run" ]; then
  echo Starting schedule_run
  while [ 1 ]
  do
    php artisan schedule:run
    sleep 60
  done

else
  echo Starting web
  /usr/bin/supervisord -c /supervisord.conf

fi
