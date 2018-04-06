FROM arm32v6/alpine:3.6 as builder
LABEL maintainer="glenn.goffin@gmail.com"

# Add qemu support for build agent
ADD https://github.com/multiarch/qemu-user-static/releases/download/v2.11.0/qemu-arm-static /usr/bin/qemu-arm-static

RUN apk update \
    && apk add --no-cache \
        ca-certificates ffmpeg opus python3 libsodium py-virtualenv ansible

# Install build dependencies
RUN apk add --no-cache \
    gcc git libffi-dev libsodium-dev make musl-dev python3-dev

# Clone Musicbot
ARG ARG_MUSICBOT_VERSION
ARG ARG_MUSICBOT_DIR="/app/musicbot"
ARG ARG_VENV_DIR="/app/venv"
ENV ENV_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION
ENV ENV_MUSICBOT_DIR=$ARG_MUSICBOT_DIR
ENV ENV_VENV_DIR=$ARG_VENV_DIR
ENV APP_ENV=docker

RUN echo "Building Musicbot Release: $ENV_MUSICBOT_VERSION " && \
    git clone "https://github.com/Just-Some-Bots/MusicBot.git" "$ENV_MUSICBOT_DIR" -b master && \
    cd "$ENV_MUSICBOT_DIR" && \
    git checkout tags/$ENV_MUSICBOT_VERSION

# Build Musicbot
RUN python3 -m venv "$ENV_VENV_DIR"
RUN /bin/sh -c "source $ENV_VENV_DIR/bin/activate && \
                    cd "$ENV_MUSICBOT_DIR" && \
                    python3 -m pip install -U pip && \ 
                    python3 -m pip install --no-cache-dir -r requirements.txt && \
                    python3 -m pip install --upgrade --force-reinstall --version websockets==4.0.1 && \
                    deactivate"

# Cleanup
RUN rm -rf "$ENV_MUSICBOT_DIR/.git"

## App Image ##
FROM arm32v6/alpine:3.6
LABEL maintainer="glenn.goffin@gmail.com"

# Add qemu support for build agent
ADD https://github.com/multiarch/qemu-user-static/releases/download/v2.11.0/qemu-arm-static /usr/bin/qemu-arm-static

RUN apk update \
    && apk add --no-cache \
        ca-certificates ffmpeg opus python3 libsodium py-virtualenv ansible

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-armhf.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-armhf.tar.gz -C /

ARG ARG_MUSICBOT_VERSION
ARG ARG_MUSICBOT_DIR="/app/musicbot"
ARG ARG_VENV_DIR="/app/venv"
ENV ENV_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION
ENV ENV_MUSICBOT_DIR=$ARG_MUSICBOT_DIR
ENV ENV_VENV_DIR=$ARG_VENV_DIR
ENV APP_ENV=docker

# Copy files from builder
COPY --from=builder /app /app

# Include root and Dockerfile
COPY root /
COPY dockerfiles/alpine-3.6/arm32v6/Dockerfile /Dockerfile

# Permission fix
RUN chmod +x /entrypoint.sh && \
    chmod +x -R /app/ansible/roles/musicbot/files && \
    chmod +x -R /app/s6/

# Label Application
LABEL app-name="musicbot"
LABEL app-version="$ENV_MUSICBOT_VERSION"

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["musicbot"]
