#!/usr/bin/env bash

set -e

CONTAINERS="${1}"
VOLUMES="${2}"
ARCHIVE_NAME=backup-$(date '+%d_%m_%Y-%H_%M_%S').tar.gz

slack_message() {
  if [ -n "${SLACK_WEBHOOK}" ]; then
    wget -O /dev/null --post-data="payload={\"text\": \"${1}\"}" "${SLACK_WEBHOOK}"
  fi
}

trap 'slack_message "Backup error on line ${LINENO}"' ERR

slack_message "Backup started"

docker stop ${CONTAINERS}

docker run \
  --rm \
  --volumes-from $(hostname) \
  ${VOLUMES} \
  busybox \
  sh -c "cd /v && tar -czf /tmp/${ARCHIVE_NAME} * && mv /tmp/${ARCHIVE_NAME} /backup/archives/"

docker start ${CONTAINERS}

find /backup/archives -maxdepth 1 -mtime +30 -type f -delete

slack_message "Backup finished"