ARG BASE_IMAGE=phpswoole/swoole:php8.2

# Set the base image for subsequent instructions
FROM ${BASE_IMAGE}

ARG DEBUG_OUTPUT=false

ENV SESSION_SAVE_PATH=/tmp/sessions \
    WWW_HOME=/var/www \
    PHP_USER_CONF_DIR=/usr/local/etc/php/conf.d \
    FRONT_CONTROLLER_FILE=index.php \
    BUILD_CONF_DIR=build-configs \
    SCRIPTS_DIR=/var/scripts/php

ENV APP_DIR=${WWW_HOME}/app
ENV DOCUMENT_ROOT=${APP_DIR}/public

# Update packages
RUN apt update --fix-missing
# Install PHP build dependencies
RUN apt-get install -yqq git libpq-dev curl\
    libcurl4-gnutls-dev libicu-dev libev-dev \
    libvpx-dev libjpeg-dev libpng-dev supervisor \
    libxpm-dev zlib1g-dev libfreetype6-dev libgrpc-dev\
    libxml2-dev libexpat1-dev libbz2-dev \
    libgmp3-dev libldap2-dev unixodbc-dev \
    libaspell-dev libsnmp-dev libzip-dev\
    libpcre3-dev libtidy-dev gnupg2 lsb-release

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

# Install needed extensions
# Here you can install any other extension that you need during the test and deployment process
RUN install-php-extensions pdo_mysql pdo_pgsql curl \
    gd xml zip bz2 soap pcntl bcmath gmp sockets intl \
    sysvmsg sysvsem sysvshm redis apcu opcache protobuf

# Install GRPC from source saves us more than 30 minutes compared to installing from pecl
RUN git clone --depth=1 https://github.com/grpc/grpc /tmp/grpc && \
    cd /tmp/grpc && \
    export GRPC_VERSION=$(git describe --tags --abbrev=0) && \
    git checkout $GRPC_VERSION && export GRPC_ROOT=$(pwd) && \
    cd /tmp/grpc/src/php/ext/grpc && \
    phpize && \
    GRPC_LIB_SUBDIR=libs/opt ./configure --enable-grpc="${GRPC_ROOT}" && \
    make && \
    make install && \
    rm -rf /tmp/grpc && \
    echo "extension=grpc.so" > $PHP_USER_CONF_DIR/grpc.ini

#COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" 
COPY "${BUILD_CONF_DIR}"/php/php.ini  "${PHP_USER_CONF_DIR}"/
RUN chown -R www-data:www-data $PHP_USER_CONF_DIR

COPY "${BUILD_CONF_DIR}"/supervisor/supervisord.conf  /etc/supervisor/supervisord.conf

RUN apt-get remove -yqq git libpq-dev \
    libcurl4-gnutls-dev libicu-dev libev-dev \
    libvpx-dev libjpeg-dev libpng-dev \
    libxpm-dev zlib1g-dev libfreetype6-dev \
    libxml2-dev libexpat1-dev libbz2-dev \
    libgmp3-dev libldap2-dev unixodbc-dev \
    libaspell-dev libsnmp-dev libzip-dev\
    libpcre3-dev libtidy-dev gnupg2 lsb-release

RUN apt-get clean -yqq && apt autoremove -yqq --purge

RUN mkdir -p ${SCRIPTS_DIR} ${APP_DIR}
COPY scripts/* "${SCRIPTS_DIR}/" 
RUN chmod +x "${SCRIPTS_DIR}/start-container.sh" "${SCRIPTS_DIR}/composer.sh"

# Expose port 8080 as the default container port
EXPOSE 8080

CMD ["bash", "${SCRIPTS_DIR}/start-container.sh" ]
