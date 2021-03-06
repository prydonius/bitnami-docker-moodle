#!/bin/bash
set -e

function initialize {
    # Package can be "installed" or "unpacked"
    status=`harpoon inspect $1`
    if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
        # Clean up inputs
        inputs=""
        if [[ -f /$1-inputs.json ]]; then
            inputs=--inputs-file=/$1-inputs.json
        fi
        harpoon initialize $1 $inputs
    fi
}

# Set default values
export MOODLE_USERNAME=${MOODLE_USERNAME:-"user"}
export MOODLE_PASSWORD=${MOODLE_PASSWORD:-"bitnami"}
export MOODLE_EMAIL=${MOODLE_EMAIL:-"user@example.com"}
export MOODLE_LANGUAGE=${MOODLE_LANGUAGE:-"en"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}
export MOODLE_SITENAME=${MOODLE_SITENAME:-"New Site"}



if [[ "$1" == "harpoon" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache moodle; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
