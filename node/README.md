# NodeJS

The NodeJS Dockerfile is based on alpine to reduce its image size. It includes npm for installing any dependencies.
We do not think that NodeJS clustering tools such as `pm2` or `throng` are needed since AbarCloud supports horizontal scaling where you can increase the number of pods that run your app instead of running multiple workers per pod.
