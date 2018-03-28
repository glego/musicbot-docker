$ARG_MUSICBOT_VERSION = "1.9.7"
$ARG_PYENV_VERSION = "3.6.4"
docker build -t glego/musicbot:latest `
    -t glego/musicbot:$ARG_MUSICBOT_VERSION `
    --build-arg ARG_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION `
    --build-arg ARG_PYENV_VERSION=$ARG_PYENV_VERSION `
    .