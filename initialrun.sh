#!/usr/bin/env bash
set -e
echo "==============================================="
echo "Initial Run Script - Part of Docker LAMP Project"
echo "By Marcus Medina, 2024"
echo "Published under the MIT License"
echo "==============================================="
echo "https://github.com/MarcusMedinaPro/DockerLamp"
echo "==============================================="
docker compose build
docker compose up -d
echo "==============================================="
