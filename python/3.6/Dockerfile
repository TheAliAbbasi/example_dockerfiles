FROM python:3.6.1

RUN apt-get update -y && \
    apt-get install -y rsync libtiff5-dev libjpeg62-turbo-dev zlib1g-dev libfreetype6-dev liblcms2-dev \
    libwebp-dev tcl8.6-dev tk8.6-dev python-tk nginx && \
    echo Asia/Tehran >/etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    mkdir /var/cache/nginx && \
    chmod -R g+ws   /var/run /var/log/ /var/lib/nginx /var/cache/nginx && \
    chown -R 1001:0 /var/run /var/log/ /var/lib/nginx /var/cache/nginx

WORKDIR /usr/src/app
EXPOSE 8080
CMD ["sh", "start.sh"]

COPY nginx.conf /etc/nginx/
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \

COPY . /tmp/app
RUN chmod -R ug+rwx /tmp/app && \
    chown -R 1001:0 /tmp/app && \
    cp -rpT /tmp/app . && \
    rm -rf /tmp/app && \
    chmod +x start.sh

USER 1001
