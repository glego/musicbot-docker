#!/bin/sh
set -e

ARG_MUSICBOT_VERSION="1.9.7"
ARG_DIST="alpine-3.6"

IS_FORCED_REBUILD_BASE="true"

ARCH=""
ARG_ARCH=""
ARG_TAG=""
ARG_TAG_LATEST=""
DOCKER_USERNAME=${DOCKER_USERNAME}
DOCKER_PASSWORD=${DOCKER_PASSWORD}

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

BUILD_PATH=$SCRIPT_PATH

check_attributes(){

    if [ "$DOCKER_USERNAME" == "" ];then
        echo "ERROR: Please provide a valid docker username."
        exit 1
    fi

    if [ "$DOCKER_PASSWORD" == "" ];then
        echo "ERROR: Please provide a valid docker password."
        exit 1
    fi
}

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

print_build_banner(){
    echo "********************************"
    echo "Building $1"
    echo "Distribution: $ARG_DIST"
    echo "Architecture: $ARG_ARCH" 
    echo "Musicbot: $ARG_MUSICBOT_VERSION"
    echo "Tag: $ARG_TAG" 
    echo "Tag: $ARG_TAG_LATEST"
    echo "********************************"
    echo "                                "
}

build_musicbot()
{
    print_build_banner "musicbot"

    cd "$BUILD_PATH"
    # musicbot
    docker build --no-cache \
        -t glego/musicbot:$ARG_TAG \
        -t glego/musicbot:$ARG_TAG_LATEST \
        --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION \
        -f ./dockerfiles/$ARG_DIST/$ARG_ARCH/Dockerfile .
    
    docker_push "musicbot"
}

build_musicbot_base()
{
    print_build_banner "musicbot-base"

    cd "$BUILD_PATH"
    # musicbot-base
    docker build --no-cache \
        -t glego/musicbot-base:$ARG_TAG \
        -t glego/musicbot-base:$ARG_TAG_LATEST \
        --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION \
        -f ./dockerfiles/$ARG_DIST-base/$ARG_ARCH/Dockerfile .
    
    docker_push "musicbot-base"
}

# Check if musicbot base needs to be rebuild
check_musicbot_base()
{
    if [ "$IS_FORCED_REBUILD_BASE" = "true" ];then
        echo "Force rebuilding base..."
        build_musicbot_base
        return 0
    fi
    rm -rf "/tmp/"*
    cd "/tmp/"
    docker run --rm glego/musicbot-base:$ARG_TAG_LATEST cat /app/requirements.sha1 > ./requirements.sha1 || build_musicbot_base
    wget "https://raw.githubusercontent.com/Just-Some-Bots/MusicBot/$ARG_MUSICBOT_VERSION/requirements.txt"
    sha1sum -c requirements.sha1 || build_musicbot_base
    echo "Checksum OK, no need to rebuild base..."
    
}

docker_login ()
{
    echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
}

docker_push ()
{
    repo=$1
    docker_login
    docker push glego/$repo:$ARG_TAG
    docker push glego/$repo:$ARG_TAG_LATEST
}

main()
{
    check_attributes
    get_cpu_architecture
    check_musicbot_base
    build_musicbot
}

main