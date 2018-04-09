FROM arm32v6/alpine:3.6 as builder
LABEL maintainer="glenn.goffin@gmail.com"

ARG ARG_MUSICBOT_VERSION
ARG ARG_MUSICBOT_DIR="/app/musicbot"
ARG ARG_VENV_DIR="/app/venv"
ENV ENV_MUSICBOT_VERSION=$ARG_MUSICBOT_VERSION
ENV ENV_MUSICBOT_DIR=$ARG_MUSICBOT_DIR
ENV ENV_VENV_DIR=$ARG_VENV_DIR

# Install build dependencies
RUN apk update \
    && apk add --no-cache \
        ca-certificates ffmpeg opus python3 libsodium py-virtualenv ansible gcc git libffi-dev libsodium-dev make musl-dev python3-dev

RUN echo "Building Musicbot Release: $ENV_MUSICBOT_VERSION " && \
    git clone "https://github.com/Just-Some-Bots/MusicBot.git" "$ENV_MUSICBOT_DIR" -b master && \
    cd "$ENV_MUSICBOT_DIR" && \
    git checkout tags/$ENV_MUSICBOT_VERSION && \
    \
    # Build Musicbot
    python3 -m venv "$ENV_VENV_DIR" && \
    /bin/sh -c "source $ENV_VENV_DIR/bin/activate && \
                    cd "$ENV_MUSICBOT_DIR" && \
                    python3 -m pip install -U pip && \
                    python3 -m pip install --no-cache-dir -r requirements.txt && \
                    python3 -m pip install --upgrade --force-reinstall --version websockets==4.0.1 && \
                    deactivate" && \
    \
    # Create checksum of the requirements
    cd "$ENV_MUSICBOT_DIR" && \
    sha1sum requirements.txt > ../requirements.sha1 && \
    cd "/" && \
    rm -rf "$ENV_MUSICBOT_DIR"

## App Image ##
FROM arm32v6/alpine:3.6
LABEL maintainer="glenn.goffin@gmail.com" \
    app-name="musicbot-base"

RUN apk update \
    && apk add --no-cache \
        ca-certificates ffmpeg opus python3 libsodium py-virtualenv ansible wget && \
    update-ca-certificates && \
    cd "/tmp/" && \
    wget "https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-armhf.tar.gz" && \
    tar xzf /tmp/s6-overlay-armhf.tar.gz -C /

# Copy files from builder
COPY --from=builder /app /app

# Include Dockerfile
COPY dockerfiles/alpine-3.6-base/arm32v6/Dockerfile /Dockerfile

# Entrypoint
CMD ["/bin/sh"]
