FROM glego/musicbot-base:arm32v6-alpine-3.6-1.9.7
LABEL maintainer="glenn.goffin@gmail.com" \
        app-name="musicbot" \
        app-version="$ENV_MUSICBOT_VERSION"

ARG ARG_MUSICBOT_VERSION
ARG ARG_MUSICBOT_DIR="/app/musicbot"
ARG ARG_VENV_DIR="/app/venv"
ENV ENV_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION
ENV ENV_MUSICBOT_DIR=$ARG_MUSICBOT_DIR
ENV ENV_VENV_DIR=$ARG_VENV_DIR
ENV APP_ENV=docker

# Installing Musicbot
RUN apk add --no-cache --virtual .build-deps \
    git && \
    echo "Cloning Musicbot Release: $ENV_MUSICBOT_VERSION " && \
    git clone "https://github.com/Just-Some-Bots/MusicBot.git" "$ENV_MUSICBOT_DIR" -b master && \
    cd "$ENV_MUSICBOT_DIR" && \
    git checkout tags/$ENV_MUSICBOT_VERSION && \
    \
    # Check if requirements did not change
    cd "$ENV_MUSICBOT_DIR" && \
    sha1sum -c ../requirements.sha1 && \
    sha1sum requirements.txt > ../requirements.sha1 && \
    \
    # Cleanup
    apk del .build-deps && \
    rm -rf "$ENV_MUSICBOT_DIR/.git"

# Include root and Dockerfile
COPY root /
COPY dockerfiles/alpine-3.6/arm32v6/Dockerfile /Dockerfile

# Permission fix
RUN chmod +x /entrypoint.sh && \
    chmod +x -R /app/ansible/roles/musicbot/files && \
    chmod +x -R /app/s6/

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["musicbot"]
