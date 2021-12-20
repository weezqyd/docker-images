# Set the base image for subsequent instructions
FROM eu.gcr.io/roamtech-gateway/php-8.0:fpm-nginx

COPY app $APP_DIR

#Override global variables
ENV DOCUMENT_ROOT="${APP_DIR}/" \
    SUPERVISOR_USERNAME="foo" \ 
    SUPERVISOR_PASSWORD="bar"

RUN chown -R www-data:www-data $APP_DIR



