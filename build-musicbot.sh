#!/bin/sh

ARG_MUSICBOT_VERSION="1.9.7"

# Get CPU Architecture
ARCH=$(lscpu | grep "Architecture" | awk '{print $2}')

echo "Architecture: $ARCH"
if [ "$ARCH" = "armv7l" ];then

    # arm32v6 musicbot build
    docker build --no-cache \
        -t glego/musicbot:arm32v6-alpine-3.6-$ARG_MUSICBOT_VERSION \
        -t glego/musicbot:arm32v6-latest \
        --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION \
        -f ./dockerfiles/alpine-3.6/arm32v6/Dockerfile .

elif [ "$ARCH" = "x86_64" ];then
    # x86_64 musicbot build
    docker build --no-cache \
        -t glego/musicbot:x86_64-alpine-3.6-$ARG_MUSICBOT_VERSION \
        -t glego/musicbot:latest \
        --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION \
        -f ./dockerfiles/alpine-3.6/x86_64/Dockerfile .

else
    echo "Could not find any valid architecture..."
fi