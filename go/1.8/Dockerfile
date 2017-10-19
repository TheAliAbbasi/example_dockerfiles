FROM alpine:3.6

ENV TZ=Asia/Tehran \
    GOROOT=/usr/lib/go \
    GOPATH=/gopath \
    GOBIN=/gopath/bin \
    GO_SOURCE_PATH=/gopath/src/github.com/MY_ORG_HERE/MY_REPO_HERE \
    GO_BINARY="MY_PROGRAM" \
    GO_ADDITIONAL_BINARIES="ANOTHER_BINARY_1 ANOTHER_BINARY_2"

RUN apk update && \
    # Install required packages - you can find any additional packages here: https://pkgs.alpinelinux.org/packages
    apk add tzdata curl bash ca-certificates rsync && \
    # Set the timezone
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    # Clean up packages
    apk del tzdata && \
    rm -rf /var/cache/apk/*

WORKDIR $GO_SOURCE_PATH

COPY . .

# Install tools for building the application and build the application
RUN apk update && \
    apk add --virtual .build-deps git 'go<1.9' libc-dev make && \
    make build && \
    mv $GO_BINARY $GO_ADDITIONAL_BINARIES /gopath/bin && \
    /gopath/bin/glide cache-clear && \
    apk del .build-deps && \
    rm -rf /gopath/pkg /gopath/src /gopath/bin/glide && \
    rm -rf /var/cache/apk/*

WORKDIR /gopath/bin

CMD ["/gopath/bin/$GO_BINARY"]
USER 1001
