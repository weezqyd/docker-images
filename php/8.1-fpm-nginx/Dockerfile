# Set the base image for subsequent instructions
FROM php:8.1-fpm

# Update packages
RUN apt-get update --fix-missing
# Install PHP and composer dependencies
RUN apt-get install -yqq git libpq-dev \
    libcurl4-gnutls-dev libicu-dev libev-dev \
    libvpx-dev libjpeg-dev libpng-dev \
    libxpm-dev zlib1g-dev libfreetype6-dev \
    libxml2-dev libexpat1-dev libbz2-dev \
    libgmp3-dev libldap2-dev unixodbc-dev \
    libaspell-dev libsnmp-dev libzip-dev\
    libpcre3-dev libtidy-dev gnupg2 lsb-release

# Clear out the local repository of retrieved package files
RUN apt-get clean

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions
# Install needed extensions
# Here you can install any other extension that you need during the test and deployment process
RUN install-php-extensions  pdo_mysql pdo_pgsql curl intl \
gd xml zip bz2 soap pcntl bcmath gmp sockets protobuf \
grpc-stable sysvmsg sysvsem sysvshm redis apcu opcache @composer

#COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

ENV NGINX_DIR=/etc/nginx \
    APP_DIR=/app \
    NGINX_USER_CONF_DIR=/etc/nginx/conf.d \
    UPLOAD_DIR=/upload \
    SESSION_SAVE_PATH=/tmp/sessions \
    WWW_HOME=/var/www \
    DOCUMENT_ROOT=/app/public \
    PHP_USER_CONF_DIR=/usr/local/etc/php/conf.d \
    FRONT_CONTROLLER_FILE=index.php \
    BUILD_CONF_DIR=build-configs \
    SCRIPTS_DIR=/var/scripts/php-8.1 \
    SUPERVISOR_USERNAME="admin" \
    SUPERVISOR_PASSWORD="secret"

# Expose port 9000 and start php-fpm server
EXPOSE 8080

ARG DEBUG_OUTPUT=false

RUN  apt-get update --fix-missing && apt-get install -yqq nginx-core nginx-common nginx nginx-full libnginx-mod-http-lua supervisor && nginx -V
# Put other config and shell files into place.
COPY "${BUILD_CONF_DIR}"/nginx/nginx.conf "${BUILD_CONF_DIR}"/nginx/fastcgi_params "${BUILD_CONF_DIR}"/nginx/gzip_params "${NGINX_DIR}"/
COPY "${BUILD_CONF_DIR}"/nginx/nginx-app.conf "${BUILD_CONF_DIR}"/nginx/nginx-http.conf "${NGINX_USER_CONF_DIR}"/

RUN chown -R www-data:www-data $NGINX_DIR

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" 

COPY "${BUILD_CONF_DIR}"/php/php.ini  "${PHP_USER_CONF_DIR}"/

RUN chown -R www-data:www-data $PHP_USER_CONF_DIR

RUN nginx -t && apt-get clean -yqq && apt autoremove -yqq --purge

COPY "${BUILD_CONF_DIR}"/supervisor/supervisord.conf  /etc/supervisor/supervisord.conf

EXPOSE 9090

RUN mkdir -p ${SCRIPTS_DIR} ${APP_DIR}

COPY scripts/* "${SCRIPTS_DIR}/" 

RUN chmod +x "${SCRIPTS_DIR}/start-container.sh" "${SCRIPTS_DIR}/composer.sh"

ENTRYPOINT ["bash", "${SCRIPTS_DIR}/start-container.sh" ]

