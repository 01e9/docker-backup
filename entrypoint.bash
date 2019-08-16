#!/usr/bin/env bash

usage() {
    echo "Usage:   -c container_a -c container_b -d volume_a:dir_a  -d volume_b:dir_b";
    echo "Example: -c webserver   -c mysql       -d uploads:uploads -d mysql_data:database"
    exit 1;
}

CONTAINERS=""
VOLUMES=""

while getopts ":c:d:" o; do
    case "${o}" in
        c)
            CONTAINERS="${CONTAINERS} ${OPTARG}";;
        d)
            VOLUMES="${VOLUMES} -v ${OPTARG//:/:\/volumes\/}:ro";;
        *)
            usage;;
    esac
done

if [ -z "${CONTAINERS}" ] || [ -z "${VOLUMES}" ]; then
    usage
fi

# trim
CONTAINERS=$(echo "${CONTAINERS}" | xargs)
VOLUMES=$(echo "${VOLUMES}" | xargs)

echo "Containers: ${CONTAINERS}"
echo "Volumes: ${VOLUMES}"

/resilio.start.bash

while true
do
    SLEEP_SECONDS=$(($(date -d "tomorrow ${BACKUP_TIME}" +%s) - $(date +%s)))
    echo "Sleeping ${SLEEP_SECONDS} seconds until ${BACKUP_TIME}"
    sleep ${SLEEP_SECONDS}

    echo "Backup started"
    /backup.bash "${CONTAINERS}" "${VOLUMES}"
    echo "Backup finished"
done
