# NodeJS

See [Dockerhub](https://hub.docker.com/_/node/) for tags that can be used in the Dockerfile `FROM` line.

If you use Babel, you need to set the `BABEL_DISABLE_CACHE=1` env variable in the AbarCloud deploymentConfig. Babel cache won't be useful with Docker as containers do not keep their state (generating a cache on container start increases the start time).
