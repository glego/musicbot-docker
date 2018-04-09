$ARG_MUSICBOT_VERSION = "1.9.7"

# x64 builds
docker build --no-cache `
        -t glego/musicbot:x86_64-alpine-3.6-$ARG_MUSICBOT_VERSION `
        -t glego/musicbot:latest `
        --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION `
        -f ./dockerfiles/alpine-3.6/x86_64/Dockerfile .