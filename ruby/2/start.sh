#!/bin/bash

# Prefix `bundle` with `exec` so unicorn shuts down gracefully on SIGTERM (i.e. `docker stop`)
if [ "$ENTRYPOINT" = "workers" ]
then
  echo Starting workers
  exec bundle exec sidekiq
elif [ "$ENTRYPOINT" = "web" ]
then
  echo Starting web
  exec bundle exec puma -C puma.rb
else
  echo Error, cannot find entrypoint to start
fi
