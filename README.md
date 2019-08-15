# Backup docker volumes

**stop containers** -> **archive volumes** -> **start containers** 

## Usage

```sh
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    01e9/docker-backup \
    -c some_container \
    -d some_volume_name:some_dir_name \
    -c another_container \
    -d another_volume_name:another_dir_name \
    -d more_volume_name:more_dir_name
```

## Optional environment variables

* `BACKUP_TIME='03:00:00'`
* `SLACK_WEBHOOK='https://hooks.slack.com/services/...'`

    https://api.slack.com/incoming-webhooks
