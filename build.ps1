$ARG_MUSICBOT_VERSION = "1.9.7"
docker build -t glego/musicbot:latest `
    -t glego/musicbot:$ARG_MUSICBOT_VERSION `
    --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION `
    .