# MusicBot Docker
[![Build Status](https://api.travis-ci.org/glego/musicbot-docker.svg?branch=master)](https://travis-ci.org/glego/musicbot-docker)
[![Docker Stars](https://img.shields.io/docker/stars/glego/musicbot.svg?maxAge=2592000)](https://hub.docker.com/r/glego/musicbot/)
[![Docker Pulls](https://img.shields.io/docker/pulls/glego/musicbot.svg?maxAge=2592000)](https://hub.docker.com/r/glego/musicbot/)

[`MusicBot-Docker`](https://hub.docker.com/r/glego/musicbot/) is a fully stateless and immutable Docker implementation of [`MusicBot`](https://github.com/Just-Some-Bots/MusicBot). Compared to other docker projects, the configuration is done via environment variables and does not require any configuration injection or external files. The Ansible Playbook will configure the application followed by an s6-overlay to control the application processes. The application is built inside a Python3 virtual environment [(venv)]( https://docs.python.org/3/library/venv.html), to ensure all python dependencies are within one directory.  This is important as the application is first built in one container, and then copied into another container, to make the smalletst Docker image possible.

## Get started

### 1. Prerequisites

* Docker
* Discord server
* [Discord Token](docs/images/discord_create_app_token.gif) at [discordapp.com/developers](https://discordapp.com/developers/applications/me)  (ENV_MUSICBOT_TOKEN)

### 2. Run the `glego/musicbot` Docker image with the Token

By providing only the token, the bot will join the same channel as the owner.

```
docker run --rm --name my-musicbot --detach -e "ENV_MUSICBOT_TOKEN=NDI4Njg0MzEyODg4NDc1Njc4.DZ2yfQ.vF1MIFcb4CndTZlH3u7ExBhtjbo" glego/musicbot:latest
```

Raspberry Pi 2/3 
```
docker run --rm --name my-musicbot --detach -e "ENV_MUSICBOT_TOKEN=NDI4Njg0MzEyODg4NDc1Njc4.DZ2yfQ.vF1MIFcb4CndTZlH3u7ExBhtjbo" -e "ENV_MUSICBOT_USEEXPERIMENTALEQUALIZATION=no" glego/musicbot:arm32v6-latest
```

> As the `--rm` flag was provided during the docker run command, the container will be destroyed after it's stopped

> For the Raspberry Pi the Equalizer has been disabled because of the playtime delay (will be fixed in future release)

### 3. Check the `docker logs` for the authorization url

```
docker logs my-musicbot
```

### 4. [Authorize the app](docs/images/musicbot-docker-logs.jpg) with the url

### 5. Restart the container 

```
docker restart my-musicbot
```

> Restart is required, because the bot doesn't re-join the channel automatically after authorization

## Enviroment Variables

* [`musicbot-servers`](root/app/ansible/group_vars/musicbot-servers) is the file with all supported variables.
* [`example_options.ini.j2`](root/app/ansible/roles/musicbot/templates/example_options.ini.j2) is the options.ini template.

## To-do

- [ ] Docs
- [x] Configuration Options
- [ ] Configuration Permissions
- [ ] Run user as non roo
- [ ] Add additional docker images for different base images (ubuntu/alpine/homebuild?)
- [x] Add Dockerfile for rpi (armhf/arm32v6)
- [x] Add travis!
- [ ] Add qemu image for travis multiarch crosscompile

## References

* https://github.com/Just-Some-Bots/MusicBot
* [Best Practices — Ansible Documentation](http://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#directory-layout)
* [Use multi-stage builds | Docker Documentation](https://docs.docker.com/develop/develop-images/multistage-build/)
* [Best practices for writing Dockerfiles | Docker Documentation](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
