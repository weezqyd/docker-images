#! /usr/bin/env bash

set -e

if [ -z "${GOOGLE_PROJECT_ID}" ]; then
    echo "You need to set GOOGLE_PROJECT_ID envvar."
    exit 1
fi

if [ -z "${SERVICE_NAME}" ]; then
     echo "You need to set SERVICE_NAME envvar."
    exit 1
fi
if [ -z "${ZONE}" ]; then
     echo "You need to set ZONE envvar."
    exit 1
fi
if [ -z "${CONTEXT}" ]; then
    CONTEXT="."
fi


if [ -z "${CLOUDBUILD_CONFIG}" ]; then
    CLOUDBUILD_CONFIG="./cloudbuild.yaml"
fi
for version in "8.2" "8.3" "8.4"
do
    gcloud builds submit \
        --config "${CLOUDBUILD_CONFIG}" \
        --project=${GOOGLE_PROJECT_ID} \
        --timeout 3600 \
        --substitutions _GOOGLE_PROJECT_ID=$GOOGLE_PROJECT_ID,_SERVICE_NAME=$SERVICE_NAME,_BASE_IMAGE=dunglas/frankenphp:php${version}-bookworm,_DOCKER_FILE=Dockerfile,_CONTEXT=$CONTEXT,_IMAGE=php:$version,_LOCATION=$ZONE \
        --async

    gcloud builds submit \
        --config "${CLOUDBUILD_CONFIG}" \
        --project=${GOOGLE_PROJECT_ID} \
        --timeout 3600 \
        --substitutions _GOOGLE_PROJECT_ID=$GOOGLE_PROJECT_ID,_SERVICE_NAME=$SERVICE_NAME,_BASE_IMAGE=dunglas/frankenphp:php${version}-alpine,_DOCKER_FILE=Dockerfile.alpine,_CONTEXT=$CONTEXT,_IMAGE=php:${version}-alpine,_LOCATION=$ZONE \
        --async
done