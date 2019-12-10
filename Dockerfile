FROM alpine:latest

# greet me :)
MAINTAINER Tobias Rös - <roes@amicaldo.de>

# install dependencies
RUN apk update && apk add \
  bash \
  git \
  nodejs \
  nodejs-npm \
  nginx


# remove default content
RUN rm -R /var/www/*

# create directory structure
RUN mkdir -p /etc/nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /etc/nginx/global
RUN mkdir -p /var/www/html

# touch required files
RUN touch /var/log/nginx/access.log && touch /var/log/nginx/error.log

# install vhost config
ADD ./config/vhost.conf /etc/nginx/conf.d/default.conf

# install webroot files
ADD ./ /var/www/html/

# To handle 'not get uid/gid'
RUN npm config set unsafe-perm true

# install bower dependencies
RUN npm install -g yarn && cd /var/www/html/ && yarn install

# install speedtest-net
RUN npm install -g https://github.com/aanon4/speedtest.net.git

# run first speedtest
# RUN cd /var/www/html/scripts && ./speedtest.js

EXPOSE 80
EXPOSE 443

VOLUME /var/www/html/data

RUN chmod +x /var/www/html/config/run.sh
ENTRYPOINT ["/var/www/html/config/run.sh"]
