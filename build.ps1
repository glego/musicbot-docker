$ARG_MUSICBOT_VERSION = "1.9.7"

# x64 builds
docker build -t glego/musicbot:latest `
    -t glego/musicbot:$ARG_MUSICBOT_VERSION `
    --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION `
    -f .\dockerfiles\ubuntu-16.04\x86_64\Dockerfile .