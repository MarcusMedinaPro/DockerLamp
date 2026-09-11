#!/usr/bin/env bash
set -e
echo "==============================================="
echo "Build Script - Part of Docker LAMP Project"
echo "By Marcus Medina, 2024"
echo "Published under the MIT License"
echo "==============================================="
echo "https://github.com/MarcusMedinaPro/DockerLamp"
echo "==============================================="
docker compose build
echo
echo "You can now use ./run.sh to start using the docker image"
echo "==============================================="
