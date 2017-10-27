FROM alpine:3.6

ENV TZ=Asia/Tehran

RUN apk update && \
    # Install required packages - you can find any additional packages here: https://pkgs.alpinelinux.org/packages
    apk add tzdata curl bash ca-certificates rsync supervisor nginx \
            python3 uwsgi-python3 && \
    # Set the timezone
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    # Setup permissions
    touch /.python_history && \
    mkdir -p /run/nginx /var/lib/nginx/logs && \
    chgrp -R 0        /.python_history /var/log /var/run /var/tmp /run/nginx /var/lib/nginx && \
    chmod -R g=u,a+rx /.python_history /var/log /var/run /var/tmp /run/nginx /var/lib/nginx && \
    # Fix python paths
    ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    # Log aggregation
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    # Clean up packages
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app
EXPOSE 8080

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . /tmp/app
RUN chgrp -R 0 /tmp/app && \
    chmod -R g=u /tmp/app && \
    cp -a /tmp/app/. . && \
    rm -rf /tmp/app && \
    chmod +x start.sh

CMD ["./start.sh"]
USER 1001
