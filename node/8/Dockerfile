FROM node:8-alpine

ENV TZ=Asia/Tehran \
    # If you use Babel, Babel cache won't be useful with Docker as containers do not keep their state
    # (generating a cache on container start increases the start time).
    BABEL_DISABLE_CACHE=1

RUN apk update && \
    # Install required packages - you can find any additional packages here: https://pkgs.alpinelinux.org/packages
    apk add tzdata curl bash ca-certificates rsync \
            python python-dev py-pip build-base libpng-dev autoconf automake nasm libtool && \
    # Set the timezone
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    # Clean up packages
    rm -rf /var/cache/apk/*

EXPOSE 3000

# Create app directory
RUN mkdir -p /usr/src/app /.config
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/

RUN npm install

# Bundle app source
COPY . /tmp/app
RUN chmod -R g+w /tmp/app /.config && \
    cp -a /tmp/app/. /usr/src/app && \
    rm -rf /tmp/app

# Set max_old_space_size to around 40Mi less than the amount of RAM for your deployment (default is 200Mi)
# Set app.js to your starting file
CMD ["node", "--optimize_for_size", "--max_old_space_size=160", "--gc_interval=100", "app.js"]
USER 1001
