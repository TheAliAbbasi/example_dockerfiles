# Python

The Python Dockerfile is based on alpine to reduce its image size.

It included uWSGI and nginx and runs them in a single container using supervisord.

A basic nginx configuration is provided, we recommend you edit it as required, e.g. to redirect your non-www domain to www and add make nginx serve and cache static assets.

It also includes a sample of how to run multiple entrypoints for workers from the same image. To customize this you will need to edit the `start.sh` script.
