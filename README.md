# MusicBot Docker
[![Docker Stars](https://img.shields.io/docker/stars/glego/musicbot.svg?maxAge=2592000)](https://hub.docker.com/r/glego/musicbot/)
[![Docker Pulls](https://img.shields.io/docker/pulls/glego/musicbot.svg?maxAge=2592000)](https://hub.docker.com/r/glego/musicbot/)

[`MusicBot-Docker`](https://hub.docker.com/r/glego/musicbot/) is a fully stateless docker implementation of [`MusicBot`](https://github.com/Just-Some-Bots/MusicBot). It plays requested/playlist songs from youtube or other servers into a discord server. The bot features a command system which can control the bot from an text channel. 

## Get started

1. Prerequisites

* Docker
* Discord server
* [Discord Token](docs/images/discord_create_app_token.gif) at [discordapp.com/developers](https://discordapp.com/developers/applications/me)  (ENV_MUSICBOT_TOKEN)
* [Developer Mode Enabled](docs/images/discord_enable_developer_mode.gif) to enable the copy id function
* [ID for the text channel](docs/images/discord_copy_id_music_bot_text.jpg) (ENV_MUSICBOT_BINDTOCHANNELS)
* [ID id for the voice channel](docs/images/discord_copy_id_music_bot_voice.jpg) (ENV_MUSICBOT_AUTOJOINCHANNELS)

2. Run the `glego/musicbot` image in Docker

```
docker run --rm --name my-musicbot --detach -e "ENV_MUSICBOT_TOKEN=NDI4Njg0MzEyODg4NDc1Njc4.DZ2yfQ.vF1MIFcb4CndTZlH3u7ExBhtjbo" -e "ENV_MUSICBOT_BINDTOCHANNELS=428689410847146004" -e "ENV_MUSICBOT_AUTOJOINCHANNELS=428688437772550154" glego/musicbot
```

> Replace the variables `ENV_MUSICBOT_TOKEN`, `ENV_MUSICBOT_BINDTOCHANNELS` and `ENV_MUSICBOT_AUTOJOINCHANNELS`

> As the `--rm` flag was provided during the docker run command, the container will be destroyed after it's stopped

3. Check the `docker logs` for the authorization url

```
docker logs my-musicbot
```

4. [Authorize the app](docs/images/musicbot-docker-logs.jpg) with the url

5. Restart the container (because the bot doesn't re-join after failed attempt)

```
docker restart my-musicbot
```

## Enviroment Variables

* [`musicbot-servers`](root/app/ansible/group_vars/musicbot-servers) is the file with all the currently supported variables.
* [`example_options.ini.j2`](root/app/ansible/roles/musicbot/templates/example_options.ini.j2) is the options.ini template.

## To-do
* Docs
* Configuration Options
* Configuration Permissions

## References
* https://github.com/Just-Some-Bots/MusicBot
