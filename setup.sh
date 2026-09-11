#!/usr/bin/env bash
set -e

VERSION_SETUP=2.0.0
CURRENT_FOLDER=$(basename "$PWD")

banner() {
    echo "==============================================="
    echo "Setup Script - Part of Docker LAMP Project"
    echo "By Marcus Medina, 2024"
    echo "Published under the MIT License"
    echo "==============================================="
    echo "https://github.com/MarcusMedinaPro/DockerLamp"
    echo "==============================================="
}

write_env() {
    cat > .env <<EOF
WEB_PORT=${WEB_PORT}
MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_USER=${MYSQL_USER}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
MYSQL_PASSWORD=${MYSQL_PASSWORD}
PHPMYADMIN_PORT=${PHPMYADMIN_PORT}
EOF
    echo ".env created successfully"
    echo
    echo "Web Port: ${WEB_PORT}"
    echo "MySQL Database Name: ${MYSQL_DATABASE}"
    echo "MySQL User: ${MYSQL_USER}"
    echo "MySQL Root Password: ${MYSQL_ROOT_PASSWORD}"
    echo "MySQL Password: ${MYSQL_PASSWORD}"
    echo "phpMyAdmin Port: ${PHPMYADMIN_PORT}"
    echo
    echo "==============================================="
    echo "Next: run ./build.sh, then ./run.sh"
    echo "==============================================="
}

usage() {
    banner
    echo
    echo "Help for Docker LAMP Project..."
    echo
    echo "Usage: ./setup.sh [WEB_PORT] [MYSQL_DATABASE] [MYSQL_USER] [MYSQL_ROOT_PASSWORD] [MYSQL_PASSWORD] [PHPMYADMIN_PORT (opt.)]"
    echo "if PHPMYADMIN_PORT is not provided, it will be set to WEB_PORT + 1"
    echo
    echo "./setup.sh help - display help message"
    echo "./setup.sh default - setup for default values"
    echo "./setup.sh cleanup - cleanup Docker LAMP Project"
    echo
    echo "Example: ./setup.sh 8080 mydb myuser adminpassword password 8081"
    echo
    echo "==============================================="
}

help_cmd() {
    banner
    echo
    echo "Reading credentials from .env..."
    # shellcheck disable=SC1091
    [ -f .env ] && source .env
    echo
    echo "Web Port: ${WEB_PORT}"
    echo "MySQL Database Name: ${MYSQL_DATABASE}"
    echo "MySQL User: ${MYSQL_USER}"
    echo "MySQL Root Password: ${MYSQL_ROOT_PASSWORD}"
    echo "MySQL Password: ${MYSQL_PASSWORD}"
    echo "phpMyAdmin Port: ${PHPMYADMIN_PORT}"
    echo "==============================================="
    echo "use ./build.sh to build the docker image"
    echo "use ./run.sh to start the docker image"
    echo "or use ./initialrun.sh to build and start (lazy, lol)"
    echo "use ./stop.sh to stop the docker image"
    echo "use ./test.sh to run the test suite"
    echo "use ./cleanupDocker.sh to remove docker resources"
    echo "==============================================="
}

version_cmd() {
    banner
    echo "Setup: ${VERSION_SETUP}"
    echo "==============================================="
    echo "Image versions are pinned in Dockerfile / docker-compose.yml"
    echo "See CHANGELOG.md for the current stack version history."
    echo "==============================================="
    docker --version
    echo "==============================================="
    uname -a
    echo "==============================================="
}

cleanup_cmd() {
    banner
    echo
    echo "Cleaning up Docker LAMP Project..."
    [ -f cleanupDocker.sh ] && ./cleanupDocker.sh
    [ -f .env ] && rm .env
    echo "Cleanup complete!"
}

case "$1" in
    help)
        help_cmd; exit 0 ;;
    version)
        version_cmd; exit 0 ;;
    cleanup|clean)
        cleanup_cmd; exit 0 ;;
    default)
        WEB_PORT=8080
        MYSQL_DATABASE="db${CURRENT_FOLDER}"
        MYSQL_USER=User
        MYSQL_ROOT_PASSWORD=adminpassword
        MYSQL_PASSWORD=password
        PHPMYADMIN_PORT=8081
        ;;
    marcus)
        echo "Hello Marcus!"
        WEB_PORT=8192
        MYSQL_DATABASE="db${CURRENT_FOLDER}"
        MYSQL_USER=Marcus
        MYSQL_ROOT_PASSWORD=kattskit
        MYSQL_PASSWORD=kattskit
        PHPMYADMIN_PORT=8193
        ;;
    "")
        usage; exit 0 ;;
    *)
        if [ -z "$5" ]; then
            usage; exit 0
        fi
        WEB_PORT=$1
        MYSQL_DATABASE=$2
        MYSQL_USER=$3
        MYSQL_ROOT_PASSWORD=$4
        MYSQL_PASSWORD=$5
        PHPMYADMIN_PORT=${6:-$((WEB_PORT + 1))}
        ;;
esac

banner
echo
echo "Setting up Docker LAMP Project..."
write_env
echo "Done!"
echo "==============================================="
