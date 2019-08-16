# Backup docker volumes

**stop containers** -> **archive volumes** -> **start containers** -> **delete old archives**

Archives directory is synced with [Resilio](https://www.resilio.com/platforms/desktop/).

## Usage

```sh
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    01e9/docker-backup \
    -c some_container \
    -d some_volume_name:some_dir_name \
    -c another_container \
    -d another_volume_name:another_dir_name \
    -d more_volume_name:more_dir_name/sub_dir
```

## Optional environment variables

* `BACKUP_TIME='03:00:00'`
* `TZ=Europe/Chisinau`

    Makes `BACKUP_TIME` match host machine time.

    Command to get timezone (on Ubuntu) `cat /etc/timezone`.
* `RESILIO_SECRET_RW='...'`

    By default it will be generated automatically and printed in console.

    You can find it inside container in `/etc/resilio.conf`.

    Command to generate a read/write secret `rslsync --generate-secret`.
* `SLACK_WEBHOOK='https://hooks.slack.com/services/...'`

    It will send in Slack channel messages like "Backup started/finished/error".

    https://api.slack.com/incoming-webhooks

## [docker-compose](https://docs.docker.com/compose/) example

```yaml
services:
    my_backup:
        image: 01e9/docker-backup
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock
        environment:
            TZ: "Europe/Chisinau"
            RESILIO_SECRET_RW: "A6Z...7VE"
        command: [
            "-c", "container_1",
            "-c", "container_2",
            "-d", "volume_name_1:directory_name_1",
            "-d", "volume_name_2:directory_name_2/sub_directory_1",
        ]
        restart: unless-stopped
```

