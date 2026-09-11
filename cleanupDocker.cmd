@echo off
cls
echo ===============================================
echo Cleanup Script - Part of Docker LAMP Project
echo By Marcus Medina, 2024
echo Published under the MIT License
echo ===============================================
echo https://github.com/MarcusMedinaPro/DockerLamp
echo ===============================================
echo Stopping all running containers...
docker compose down

echo Removing unused Docker volumes...
docker volume prune -f

echo Removing unused Docker networks...
docker network prune -f

echo Removing unused Docker images...
docker image prune -f

echo Removing unused Docker build cache...
docker builder prune -f

echo Removing unused Docker system resources...
docker system prune -f

echo Cleanup complete!
echo ===============================================
