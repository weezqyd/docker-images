#! /usr/bin/env bash

set -ex

if [ -z "${TAG}" ]; then
    echo "You need to set TAG envvar."
    exit 1
fi

if [ -z "${GOOGLE_PROJECT_ID}" ]; then
    echo "You need to set GOOGLE_PROJECT_ID envvar."
    exit 1
fi

if [ -z "${SERVICE_NAME}" ]; then
     echo "You need to set SERVICE_NAME envvar."
    exit 1
fi

if [ -z "${DOCKER_FILE}" ]; then
    DOCKER_FILE="."
fi

if [ -z "${DOCKER_FILE}" ]; then
    CLOUDBUILD_CONFIG="./cloudbuild.yaml"
fi

gcloud builds submit \
  --config "${CLOUDBUILD_CONFIG}" \
  --timeout 3600 \
  --substitutions _GOOGLE_PROJECT_ID=$GOOGLE_PROJECT_ID,_TAG=$TAG,_SERVICE_NAME=$SERVICE_NAME,_DOCKER_FILE=$DOCKER_FILE