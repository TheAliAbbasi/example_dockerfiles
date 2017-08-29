FROM alpine:3.6

ENV GOROOT=/usr/lib/go \
    GOPATH=/gopath \
    GOBIN=/gopath/bin

ENTRYPOINT ["/entrypoint.sh"]
# Update the next 2 lines
CMD ["/gopath/bin/MY_PROGRAM"]
WORKDIR /gopath/src/github.com/MY_ORG_HERE/MY_REPO_HERE

COPY . .

# You can lock the Go version to any version you need below
RUN apk add --no-cache --virtual .build-deps git go libc-dev make \
  && make MY_MAKE_OPTIONS_HERE \
  && mv MY_PROGRAM_1_HERE MY_PROGRAM_2_HERE /gopath/bin \
  && mv entrypoint.sh MY_OTHER_FILES_HERE / \
  && /gopath/bin/glide cache-clear \
  && apk del .build-deps \
  && rm -rf /gopath/pkg /gopath/src /gopath/bin/glide

WORKDIR /gopath/bin
