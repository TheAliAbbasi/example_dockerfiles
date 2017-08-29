#!/bin/bash

if [ "$ENTRYPOINT" = "workers" ]
then
  echo Starting workers
  celery worker -A tasks -l INFO
elif [ "$ENTRYPOINT" = "web" ]
then
  echo Starting web
  uwsgi wsgi.ini &
  nginx -g "daemon off;"
else
  echo Error, cannot find entrypoint to start
fi
