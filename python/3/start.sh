#!/bin/bash

if [ "$ENTRYPOINT" = "workers" ]
then
  echo Starting workers
  celery worker -A tasks -l INFO
elif [ -z "$ENTRYPOINT" ] || "$ENTRYPOINT" = "web" ]
then
  echo Starting web
  /usr/bin/supervisord -c /supervisord.conf
else
  echo Error, cannot find entrypoint $ENTRYPOINT to start
fi
