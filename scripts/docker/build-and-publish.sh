#!/bin/bash

REGION=eu-west-1
AWS_ACCOUNT_ID=848564091653
PROFILE=default
DOCKER_APP_NAME=viacheslav-karnaukh-cart-api

DOCKER_APP_REPOSITORY=viacheslav-karnaukh-cart-api
AWS_DOCKER_REGISTRY_URL=$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
DOCKER_TIME_TAG="$(date +%s)"
DOCKER_LATEST_TAG=latest

# Logout from Docker
docker logout
# Login in AWS container registry with your AWS credentials
aws ecr get-login-password --profile $PROFILE --region $REGION | docker login --username AWS --password-stdin $AWS_DOCKER_REGISTRY_URL
# Build Docker image
docker build \
        -f "$(dirname "$0")/../../Dockerfile" \
        -t $DOCKER_APP_REPOSITORY:"$DOCKER_TIME_TAG" \
        -t $DOCKER_APP_REPOSITORY:$DOCKER_LATEST_TAG \
        "$(dirname "$0")/../../"

# Tag Docker image
docker tag $DOCKER_APP_REPOSITORY:"$DOCKER_TIME_TAG" $AWS_DOCKER_REGISTRY_URL/$DOCKER_APP_REPOSITORY:"$DOCKER_TIME_TAG"
docker tag $DOCKER_APP_REPOSITORY:$DOCKER_LATEST_TAG $AWS_DOCKER_REGISTRY_URL/$DOCKER_APP_REPOSITORY:$DOCKER_LATEST_TAG

# Push/Publish Docker image
docker push $AWS_DOCKER_REGISTRY_URL/$DOCKER_APP_REPOSITORY:$DOCKER_LATEST_TAG