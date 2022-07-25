

#!/bin/sh

# A shell script for installing dependencies with composer.

if [ "${DEBUG_OUTPUT}" = "true" ]; then
    set -xe
else
    set -e
fi
if  test -f "${APP_DIR}/composer.json" ; then
    echo $(php -v)

    # Workaround for https://github.com/docker/docker/issues/6047
    # We want to remove when Cloud Build starts to use newer Docker.

    if [ -d "${APP_DIR}/vendor" ]; then 
        rm -Rf "${APP_DIR}/vendor"
    fi

    # Run Composer.
    echo "Running composer..."
    chown -R www-data:www-data ${APP_DIR}
    if [ -z "${COMPOSER_FLAGS}" ]; then
        COMPOSER_FLAGS='--no-scripts --no-dev --prefer-dist'
    fi
    cd ${APP_DIR} && \
        su -s /bin/ash www-data -c "/usr/local/bin/composer install \
          --optimize-autoloader \
          --no-interaction \
          --no-ansi \
          --no-progress \
          ${COMPOSER_FLAGS}"

else
    echo "No composer.json file was detected. Skipping installation of dependencies."
fi