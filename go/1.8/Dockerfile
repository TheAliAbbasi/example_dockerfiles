# Use Alpine Linux as our base Docker image since it's only 5MB in size so
# allows us to create smaller Docker images.
FROM alpine:3.6

# Modify these variables depending on your application:
# * `TZ` Timezone for the app.
# * `GO_SOURCE_PATH` The path to your Go source code.
# * `GO_BINARY` The main app binary that is built.
# * `GO_ADDITIONAL_BINARIES` Any additional binaries built for the app. Remove
#    this if there are none.
# * `GOROOT` This should not need changed.
# * `GOPATH` This should not need changed.
# * `GOBIN` This should not need changed.
ENV TZ=Asia/Tehran \
    GO_SOURCE_PATH=/gopath/src/github.com/MY_ORG_HERE/MY_REPO_HERE \
    GO_BINARY="MY_PROGRAM" \
    GO_ADDITIONAL_BINARIES="ANOTHER_BINARY_1 ANOTHER_BINARY_2" \
    GOROOT=/usr/lib/go \
    GOPATH=/gopath \
    GOBIN=/gopath/bin

# Install the base required packages for the image. Find any additional packages
# from [the Alpine package explorer](https://pkgs.alpinelinux.org/packages).
RUN apk update && \
    apk add tzdata curl bash ca-certificates rsync && \
    # Set the timezone based on the `TZ` variable above.
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    # Clean up the package cache. This reduces the size of the Docker image.
    rm -rf /var/cache/apk/*

# Set the current directory for the Docker image to the Go source path, since
# we initially want to build the Go app.
WORKDIR $GO_SOURCE_PATH

# Copy the application files.
COPY . .

# Install the packages required for building the Go application.
RUN apk update && \
    apk add --virtual .build-deps git 'go<1.9' libc-dev make && \
    # Build the application. If you are not using make, update this line to the
    # command you need for building the application.
    make build && \
    # Add the built binaries to the Go bin.
    mv $GO_BINARY $GO_ADDITIONAL_BINARIES $GOBIN && \
    # Clean up the Go packages and build dependencies. This reduces the size of
    # the Docker image.
    /gopath/bin/glide cache-clear && \
    apk del .build-deps && \
    rm -rf $GOPATH/pkg $GOPATH/src $GOBIN/glide && \
    rm -rf /var/cache/apk/*

# Set the current directory for the Docker image to the Go bin path, since
# we will now run the Go app.
WORKDIR $GOBIN

# Specify the command to run when the container starts.
CMD ${GOBIN}/${GO_BINARY}

# Specify the default user for the Docker image to run as.
USER 1001
