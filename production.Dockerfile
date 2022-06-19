ARG ALPINE_VERSION=3.15
FROM alpine:${ALPINE_VERSION}

LABEL Maintainer="Ach Rozikin <geronimo794@gmail.com>"
LABEL Description="PHP Nginx for production"

# Install packages and remove default server definition
RUN apk --no-cache add \
	curl \
	nginx \
	php7 \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-fpm \
	php7-gd \
	php7-intl \
	php7-json \
	php7-mbstring \
	php7-mysqli \
	php7-opcache \
	php7-openssl \
	php7-phar \
	php7-session \
	php7-xml \
	php7-xmlreader \
	php7-zlib \
	php7-pear \
	php7-dev \
	php7-phalcon \
	php7-pdo \
	php7-pdo_mysql \
	php7-simplexml \
	gcc \
	musl-dev \
	make \
	supervisor
	
# Configure production ENV
## Nginx configuration
COPY server/production/nginx.conf /etc/nginx/nginx.conf
## PHP Ini Custom
COPY server/production/custom.ini /etc/php7/conf.d/custom.ini

# Configure production ENV
## FPM Pool Config
COPY server/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
## PHP Ini Upload Configuration
COPY server/uploads.ini /etc/php7/conf.d/uploads.ini

# Configure supervisord
COPY server/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup php folder
RUN mkdir -p /var/www/html

# Setup document root
WORKDIR /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping