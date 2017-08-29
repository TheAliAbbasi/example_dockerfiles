# Python

We recommend deploying Python with uWSGI and NGINX for best performance. A basic NGINX configuration is provided, we recommend you edit it as required, e.g. to add make NGINX serve and cache static assets.

The setup assumes that the Python app is listening on port 9000. See `start.sh` on how the `ENTRYPOINT=web` env variable can be used to start uWSGI+NGINX; this can be set to `workers` to start Celery.
