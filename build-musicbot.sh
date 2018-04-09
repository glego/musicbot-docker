#!/bin/sh
set -e

ARG_MUSICBOT_VERSION="1.9.7"
ARG_DIST="alpine-3.6"

ARCH=""
ARG_ARCH=""
ARG_TAG=""
ARG_TAG_LATEST=""

get_cpu_architecture()
{
    # Get CPU Architecture
    ARCH=$(lscpu | grep "Architecture" | awk '{print $2}')
    echo "Architecture: $ARCH"

    if [ "$ARCH" = "armv7l" ];then
        ARG_ARCH="arm32v6"
        ARG_TAG="$ARG_ARCH-$ARG_DIST-$ARG_MUSICBOT_VERSION"
        ARG_TAG_LATEST="$ARG_ARCH-latest"
    elif [ "$ARCH" = "x86_64" ];then
        ARG_ARCH="x86_64"
        ARG_TAG="$ARG_DIST-$ARG_MUSICBOT_VERSION"
        ARG_TAG_LATEST="latest"
    else
        echo "ERROR: Could not find any valid architecture..."
        exit 1 # Exit the script
    fi
}

build_musicbot()
{
    # musicbot
    docker build --no-cache \
        -t glego/musicbot-base:$ARG_TAG \
        -t glego/musicbot-base:$ARG_TAG_LATEST
        --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION \
        -f ./dockerfiles/$ARG_DIST/$ARG_ARCH/Dockerfile .
}

build_musicbot_base()
{
    # musicbot-base
    docker build --no-cache \
        -t glego/musicbot-base:$ARG_TAG \
        -t glego/musicbot-base:$ARG_TAG_LATEST
        --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION \
        -f ./dockerfiles/$ARG_DIST-base/$ARG_ARCH/Dockerfile .
}

# Check if musicbot base needs to be rebuild
check_musicbot_base()
{
    docker run --rm glego/musicbot-base:$ARG_TAG_LATEST cat /app/requirements.sha1 > requirements.sha1 || build_musicbot_base
    wget "https://raw.githubusercontent.com/Just-Some-Bots/MusicBot/$ARG_MUSICBOT_VERSION/requirements.txt"
    sha1sum -c requirements.sha1 || build_musicbot_base
    echo "Checksum OK, no need to rebuild base..."
}

main()
{
    get_cpu_architecture
    check_musicbot_base
    build_musicbot
}

main