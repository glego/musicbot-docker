FROM ubuntu:16.04 as builder
LABEL maintainer="glenn.goffin@gmail.com"

# Prevent dpkg errors
ENV TERM=xterm-256color

# Set mirrors to DE
RUN sed -i "s/http:\/\/archive./http:\/\/de.archive./g" /etc/apt/sources.list

# Build Musicbot
# Install run dependencies
RUN apt-get update -y &&\
    apt-get install -qy \
        -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
        software-properties-common && \
    add-apt-repository ppa:mc3man/xerus-media && \
    apt-get update -y && \
    apt-get install -qy \
        -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
        ca-certificates ffmpeg python3 python3-venv ansible

# Install build dependencies
RUN apt-get install -qy \
        -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
        build-essential unzip libopus-dev libffi-dev libsodium-dev python3-pip python3-dev git
    
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

## App Image ##
FROM ubuntu:16.04
LABEL maintainer="glenn.goffin@gmail.com"

# Prevent dpkg errors
ENV TERM=xterm-256color

# Set mirrors to DE
RUN sed -i "s/http:\/\/archive./http:\/\/de.archive./g" /etc/apt/sources.list

# Install run dependencies
RUN apt-get update -y &&\
    apt-get install -qy \
        -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
        software-properties-common && \
    add-apt-repository ppa:mc3man/xerus-media && \
    apt-get update -y && \
    apt-get install -qy \
        -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
        ca-certificates ffmpeg python3 python3-venv ansible

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

# Musicbot
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
COPY dockerfiles/ubuntu-16.04/x86_64/Dockerfile /Dockerfile

# Label Application
LABEL app-name="musicbot"
LABEL app-version="$ENV_MUSICBOT_VERSION"

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["musicbot"]



