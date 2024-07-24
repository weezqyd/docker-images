ARG PROJECT_ID=my-project
ARG REPOSITORY=laravel
# Set the base image for subsequent instructions
FROM europe-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY}/php:8.3

COPY app $APP_DIR

#Override global variables
ENV DOCUMENT_ROOT=$APP_DIR

RUN chown -R www-data:www-data $APP_DIR

WORKDIR ${DOCUMENT_ROOT}

CMD [ "php", "-S", "0.0.0.0:8080", "index.php"]

