FROM alpine:3.6

ENV TZ=Asia/Tehran

RUN apk update && \
    # Install required packages
    apk add tzdata curl bash ca-certificates supervisor nginx python3 uwsgi-python3 && \
    # Set the timezone
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    # Setup permissions
    touch /.python_history && \
    mkdir -p /run/nginx /var/lib/nginx/logs && \
    chmod -R g+rws,a+rx /.python_history /var/log /var/run /var/tmp /run/nginx /var/lib/nginx && \
    chown -R 1001:0     /.python_history /var/log /var/run /var/tmp /run/nginx /var/lib/nginx && \
    # Fix python paths
    ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    # Log aggregation
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    # Clean up packages
    apk del tzdata && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app
EXPOSE 8080
CMD ["./start.sh"]

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY start.sh requirements.txt ./
COPY supervisord.conf /
RUN pip install --no-cache-dir -r requirements.txt && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY . /tmp/app
RUN chmod -R g+w /tmp/app && \
    chown -R 1001:0 /tmp/app && \
    cp -a /tmp/app/. . && \
    rm -rf /tmp/app && \
    chmod +x start.sh

USER 1001
