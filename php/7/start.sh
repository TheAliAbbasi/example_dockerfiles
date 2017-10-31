# You can use the `ENTRYPOINT` DeploymentConfig environment variable to specify
# which command to run. This allows you to use the same Dockerfile for the
# web and worker processes. You can customize this script to add any other
# entrypoints you would like. This script contains the basics for a standard
# Laravel app.
#!/bin/bash

# If the entrypoint is `workers` we run the Laravel worker
if [ "$ENTRYPOINT" = "workers" ]; then
  echo Starting workers
  php artisan queue:work --tries=3

# If the entrypoint is `schedule_run` we run the Laravel scheduler
elif [ "$ENTRYPOINT" = "schedule_run" ]; then
  echo Starting schedule_run
  while [ 1 ]
  do
    php artisan schedule:run
    sleep 60
  done

# If the entrypoint is blank or `web` we want to run the web supervisord process
elif [ -z "$ENTRYPOINT" ] || "$ENTRYPOINT" = "web" ]
then
  echo Starting web
  /usr/bin/supervisord -c /supervisord.conf

else
  echo Error, cannot find entrypoint $ENTRYPOINT to start
fi
