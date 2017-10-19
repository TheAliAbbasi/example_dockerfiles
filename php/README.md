# PHP

The PHP Dockerfile is based on alpine to reduce its image size.

It included php-fpm and nginx and runs them in a single container using supervisord.

A basic nginx configuration is provided, we recommend you edit it as required, e.g. to redirect your non-www domain to www and add make nginx serve and cache static assets.

Some PHP extensions are included but you should update the Dockerfile to add any additional ones required.

It also includes a sample of how to run multiple entrypoints for workers and schedulers from the same image. To customize this you will need to edit the `start.sh` script.
