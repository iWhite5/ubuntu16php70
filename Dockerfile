FROM ubuntu:16.04
MAINTAINER Isaac White

RUN apt-get update && apt-get install -y software-properties-common build-essential wget curl

# NGINX
RUN add-apt-repository -y ppa:nginx/stable && apt-get update && apt-get install -y nginx
COPY docker/nginx.conf /etc/nginx/nginx.conf


# PHP
RUN apt-get install -y php7.0 \
 php7.0-fpm \
 php7.0-mysql \
 php7.0-cli \
 php7.0-mbstring \
 php7.0-dom \
 php7.0-mysql \
 php7.0-pgsql \
 php7.0-sqlite \
 php7.0-curl \
 php7.0-gd \
 php7.0-gmp \
 php7.0-mcrypt \
 php7.0-intl \
 php7.0-json \
 php7.0-dev \
 php-pear

# VIM
RUN apt-get update && apt-get install -y vim

# GIT
RUN apt-get update && apt-get install -y git

# Nodejs and NPM
RUN apt-get install -y npm \
 nodejs-legacy
RUN npm install -g n
RUN n latest
RUN npm install npm@latest -g

## Composer
RUN curl -sS https://getcomposer.org/installer | php && \
 mv composer.phar /usr/local/bin/composer

# Robo
RUN wget http://robo.li/robo.phar && chmod +x robo.phar && mv robo.phar /usr/local/bin/robo

# Supervisor
RUN apt-get update && apt-get install -y supervisor

EXPOSE 80 443 8000 8001 8002

RUN mkdir -p /run/php
RUN mkdir -p /etc/iwhite/docker
RUN mkdir -p /var/www/php/public

COPY docker/php/docker/nginx /etc/iwhite/docker/nginx
COPY docker/www.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY docker/supervisord.conf /etc/iwhite/docker/supervisord.conf

CMD /usr/bin/supervisord -c /etc/iwhite/docker/supervisord.conf

RUN echo "alias d='cd /var/www/php'" >> ~/.bashrc

