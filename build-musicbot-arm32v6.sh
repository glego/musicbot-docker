#!/bin/sh

ARG_MUSICBOT_VERSION="1.9.7"

# arm32v6 builds
docker build -t glego/musicbot-base:arm32v6-alpine-3.6-$ARG_MUSICBOT_VERSION \
    --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION \
    -f ./dockerfiles/alpine-3.6-base/arm32v6/Dockerfile .