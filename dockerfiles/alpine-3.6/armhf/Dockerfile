FROM armhf/alpine:3.6 as builder
LABEL maintainer="glenn.goffin@gmail.com"

RUN apk update \
    && apk add --no-cache \
        ca-certificates ffmpeg opus python3 py-virtualenv ansible

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
RUN /bin/bash -c "source $ENV_VENV_DIR/bin/activate && \
                    cd "$ENV_MUSICBOT_DIR" && \
                    python3 -m pip install -U pip && \ 
                    python3 -m pip install -U -r requirements.txt && \
                    deactivate"

# Cleanup
RUN rm -rf "$ENV_MUSICBOT_DIR/.git"

LABEL maintainer="glenn.goffin@gmail.com"

RUN apk update \
    && apk add --no-cache \
        ca-certificates ffmpeg opus python3 py-virtualenv ansible

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
COPY dockerfiles/alpine-3.6/armhf/Dockerfile /Dockerfile

# Label Application
LABEL app-name="musicbot"
LABEL app-version="$ENV_MUSICBOT_VERSION"

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["musicbot"]
