@echo off
setlocal enabledelayedexpansion

rem Define version numbers, 
rem always update minor value when editing this file
rem but only when actually changing the script
rem i.e you change the run script, update the run version
rem whatever change, always increase the minor version of setup
set VERSION_SETUP=1.1.9
set VERSION_RUN=1.0.1
set VERSION_BUILD=1.0.1
set VERSION_STOP=1.0.1
set VERSION_TEST=1.0.1
set VERSION_CLEANUP=1.1.1
set DOCKERFILE_VERSION=1.0.1
set DOCKER_COMPOSE_VERSION=1.0.1
rem ...and the version of the software
set MYSQL_VERSION=8.4.0
set PHP_VERSION=8.2.20
set PHPMYADMIN_VERSION=5.2.1
set APACHE_VERSION=2.4.59
rem --------------------------------------------

cls
echo ===============================================
echo Setup Script - Part of Docker LAMP Project
echo By Marcus Medina, 2024
echo Published under the MIT License
echo ===============================================
echo https://github.com/MarcusMedinaPro/DockerLamp
echo ===============================================
echo.
echo Setting up Docker LAMP Project...

for %%i in (.) do set CURRENT_FOLDER=%%~nxi

rem Define the array globally as a space-separated list
set files=build.cmd cleanupDocker.cmd initialrun.cmd run.cmd stop.cmd test.cmd

if "%1"=="help" goto :help
if "%1"=="default" goto :default
if "%1"=="marcus" goto :marcus
if "%1"=="clean" goto :cleanup
if "%1"=="cleanup" goto :cleanup
if "%1"=="version" goto :version
if "%1"=="" goto :usage
if "%5"=="" goto :usage

set WEB_PORT=%1
set MYSQL_DATABASE=%2
set MYSQL_USER=%3
set MYSQL_ROOT_PASSWORD=%4
set MYSQL_PASSWORD=%5

if "%6"=="" (
    set /a PHPMYADMIN_PORT=%WEB_PORT% + 1
) else (
    set PHPMYADMIN_PORT=%6
)

goto :generate_files

:default
echo Setting up for Default...
set WEB_PORT=8080

set MYSQL_DATABASE=db%CURRENT_FOLDER%
set MYSQL_USER=User
set MYSQL_ROOT_PASSWORD=adminpassword
set MYSQL_PASSWORD=password
set PHPMYADMIN_PORT=8081

goto :generate_files

:marcus
echo Setting up for Marcus...
echo Hello Marcus!
set WEB_PORT=8192

set MYSQL_DATABASE=db%CURRENT_FOLDER%
set MYSQL_USER=Marcus
set MYSQL_ROOT_PASSWORD=kattskit
set MYSQL_PASSWORD=kattskit
set PHPMYADMIN_PORT=8193

goto :generate_files

:cleanup
cls
echo ===============================================
echo Cleanup Script - Part of Docker LAMP Project
echo By Marcus Medina, 2024
echo Published under the MIT License
echo ===============================================
echo https://github.com/MarcusMedinaPro/DockerLamp
echo ===============================================
echo.
echo Cleaning up Docker LAMP Project...

if exist cleanupDocker.cmd (
    call cleanupDocker.cmd
)

rem Delete generated files
for %%f in (%files%) do (
    if exist %%f del %%f
)

echo Cleanup complete!
goto :eof

:version
cls
echo ===============================================
echo Version Script - Part of Docker LAMP Project
echo By Marcus Medina, 2024
echo Published under the MIT License
echo ===============================================
echo https://github.com/MarcusMedinaPro/DockerLamp
echo ===============================================
echo Setup        : %VERSION_SETUP%
echo run          : %VERSION_RUN%
echo build        : %VERSION_BUILD%
echo stop         : %VERSION_STOP%
echo test         : %VERSION_TEST%
echo cleanupDocker: %VERSION_CLEANUP%
echo Dockerfile   : %DOCKERFILE_VERSION%
echo DockerCompose: %DOCKER_COMPOSE_VERSION%
echo ===============================================
echo MySQL        : %MYSQL_VERSION%
echo PHP          : %PHP_VERSION%
echo phpMyAdmin   : %PHPMYADMIN_VERSION%
echo Apache       : %APACHE_VERSION%
echo ===============================================
docker --version
echo ===============================================
ver
echo ===============================================

goto :eof

:usage
cls
echo ===============================================
echo Usage Script - Part of Docker LAMP Project
echo By Marcus Medina, 2024
echo Published under the MIT License
echo ===============================================
echo https://github.com/MarcusMedinaPro/DockerLamp
echo ===============================================
echo.
echo Help for Docker LAMP Project...
echo.
echo Usage: setup [WEB_PORT] [MYSQL_DATABASE] [MYSQL_USER] [MYSQL_ROOT_PASSWORD] [MYSQL_PASSWORD] [PHPMYADMIN_PORT (opt.)]
echo if PHPMYADMIN_PORT is not provided, it will be set to WEB_PORT + 1
echo.
echo setup help - display help message
echo setup default - setup for default values
echo setup cleanup - cleanup Docker LAMP Project
echo.
echo Example: setup 8080 mydb myuser adminpassword password 8081
echo.
echo ===============================================

goto :eof

:help
cls
echo ===============================================
echo Help Script - Part of Docker LAMP Project
echo By Marcus Medina, 2024
echo Published under the MIT License
echo ===============================================
echo https://github.com/MarcusMedinaPro/DockerLamp
echo ===============================================
echo.
echo Reading docker-compose.yml for credentials...
for /f "tokens=3" %%i in ('findstr MYSQL_ROOT_PASSWORD docker-compose.yml') do set MYSQL_ROOT_PASSWORD=%%i
for /f "tokens=3" %%i in ('findstr MYSQL_DATABASE docker-compose.yml') do set MYSQL_DATABASE=%%i
for /f "tokens=3" %%i in ('findstr MYSQL_USER docker-compose.yml') do set MYSQL_USER=%%i
for /f "tokens=3" %%i in ('findstr MYSQL_PASSWORD docker-compose.yml') do set MYSQL_PASSWORD=%%i
for /f "tokens=2 delims=: " %%i in ('findstr ports.*80 docker-compose.yml ^| findstr -v PHPMYADMIN') do set WEB_PORT=%%i
for /f "tokens=2 delims=: " %%i in ('findstr ports.*80 docker-compose.yml ^| findstr PHPMYADMIN') do set PHPMYADMIN_PORT=%%i

echo.
echo Web Port: %WEB_PORT%
echo MySQL Database Name: %MYSQL_DATABASE%
echo MySQL User: %MYSQL_USER%
echo MySQL Root Password: %MYSQL_ROOT_PASSWORD%
echo MySQL Password: %MYSQL_PASSWORD%
echo phpMyAdmin Port: %PHPMYADMIN_PORT%
echo ===============================================
echo use build.cmd to start building the docker image
echo use run.cmd to start using the docker image
echo or use initialrun.cmd to build and start the docker image (lazy, lol)
echo use stop.cmd to stop the docker image
echo use cleanupDocker.cmd to remove the docker image
echo ===============================================

goto :eof

:generate_files
rem Delete existing files
for %%f in (%files%) do (
    if exist %%f del %%f
)

rem Ensure .gitignore file exists
if not exist .gitignore type nul > .gitignore

rem Add generated files to .gitignore (if they don't already exist)
for %%f in (%files%) do (
    findstr /c:"%%f" .gitignore >nul || echo %%f>> .gitignore
)

echo Creating docker-compose.yml...
(
rem version is deprecated in docker-compose.yml
rem echo version: '%DOCKER_COMPOSE_VERSION%'
echo services:
echo   web:
echo     build: .
echo     ports:
echo       - "%WEB_PORT%:80"
echo     volumes:
echo       - ./public:/var/www/html
echo       - ./vendor:/var/www/html/vendor
echo     environment:
echo       MYSQL_ROOT_PASSWORD: %MYSQL_ROOT_PASSWORD%
echo       MYSQL_DATABASE: %MYSQL_DATABASE%
echo       MYSQL_USER: %MYSQL_USER%
echo       MYSQL_PASSWORD: %MYSQL_PASSWORD%
echo     depends_on:
echo       - db
echo   db:
echo     image: mysql:%MYSQL_VERSION%
echo     restart: always
echo     environment:
echo       MYSQL_ROOT_PASSWORD: %MYSQL_ROOT_PASSWORD%
echo       MYSQL_DATABASE: %MYSQL_DATABASE%
echo       MYSQL_USER: %MYSQL_USER%
echo       MYSQL_PASSWORD: %MYSQL_PASSWORD%
echo     volumes:
echo       - db_data:/var/lib/mysql
echo   phpmyadmin:
echo     image: phpmyadmin:%PHPMYADMIN_VERSION%
echo     restart: always
echo     ports:
echo       - "%PHPMYADMIN_PORT%:80"
echo     environment:
echo       PMA_HOST: db
echo       MYSQL_ROOT_PASSWORD: %MYSQL_ROOT_PASSWORD%
echo   test:
echo     build: .
echo     volumes:
echo       - ./public:/var/www/html
echo       - ./vendor:/var/www/html/vendor
echo     entrypoint: ["vendor/bin/phpunit"]
echo     depends_on:
echo       - db
echo volumes:
echo   db_data:
) > docker-compose.yml

echo Creating Dockerfile...
(
echo # Use the official PHP image with Apache
echo FROM php:%PHP_VERSION%-apache
echo.
echo # Install necessary packages and PHP extensions
echo RUN apt-get update ^&^& apt-get install -y \
echo     libpng-dev \
echo     libjpeg-dev \
echo     libfreetype6-dev \
echo     libzip-dev \
echo     zip \
echo     unzip \
echo     ^&^& docker-php-ext-configure gd --with-freetype --with-jpeg \
echo     ^&^& docker-php-ext-install gd \
echo     ^&^& docker-php-ext-install zip \
echo     ^&^& docker-php-ext-install mysqli pdo pdo_mysql \
echo     ^&^& a2enmod rewrite
echo.
echo # Install Composer
echo COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
echo.
echo # Set working directory
echo WORKDIR /var/www/html
echo.
echo # Copy application files
echo COPY public/ /var/www/html/
echo.
echo # Install PHPUnit
echo RUN composer require --dev phpunit/phpunit
echo.
echo # Expose port 80
echo EXPOSE 80
) > Dockerfile

echo Creating build.cmd...
(
echo @echo off
echo cls
echo echo ===============================================
echo echo Build Script - Part of Docker LAMP Project
echo echo By Marcus Medina, 2024
echo echo Published under the MIT License
echo echo ===============================================
echo echo https://github.com/MarcusMedinaPro/DockerLamp
echo echo ===============================================
echo docker-compose build
echo echo.
echo echo You can now use run.cmd to start using the docker image
echo.
echo echo ===============================================
) > build.cmd

echo Creating run.cmd...
(
echo @echo off
echo cls
echo echo ===============================================
echo echo Run Script - Part of Docker LAMP Project
echo echo By Marcus Medina, 2024
echo echo Published under the MIT License
echo echo ===============================================
echo echo https://github.com/MarcusMedinaPro/DockerLamp
echo echo ===============================================
echo start docker-compose up
echo echo Docker LAMP Project is now running!
echo echo ===============================================

) > run.cmd

echo Creating stop.cmd...
(
echo @echo off
echo cls
echo echo ===============================================
echo echo Stop Script - Part of Docker LAMP Project
echo echo By Marcus Medina, 2024
echo echo Published under the MIT License
echo echo ===============================================
echo echo https://github.com/MarcusMedinaPro/DockerLamp
echo echo ===============================================
echo docker-compose down
echo echo ===============================================
) > stop.cmd

echo Creating test.cmd...
(
echo @echo off
echo cls
echo echo ===============================================
echo echo Test Script - Part of Docker LAMP Project
echo echo By Marcus Medina, 2024
echo echo Published under the MIT License
echo echo ===============================================
echo echo https://github.com/MarcusMedinaPro/DockerLamp
echo echo ===============================================
echo docker-compose run test
echo echo ===============================================
) > test.cmd

echo Creating cleanupDocker.cmd...
(
echo @echo off
echo cls
echo echo ===============================================
echo echo Cleanup Script - Part of Docker LAMP Project
echo echo By Marcus Medina, 2024
echo echo Published under the MIT License
echo echo ===============================================
echo echo https://github.com/MarcusMedinaPro/DockerLamp
echo echo ===============================================
echo echo Stopping all running containers...
echo docker-compose down
echo.
echo echo Removing unused Docker volumes...
echo docker volume prune -f
echo.
echo echo Removing unused Docker networks...
echo docker network prune -f
echo.
echo echo Removing unused Docker images...
echo docker image prune -f
echo.
echo echo Removing unused Docker build cache...
echo docker builder prune -f
echo.
echo echo Removing unused Docker system resources...
echo docker system prune -f
echo.
echo echo Cleanup complete!
echo echo ===============================================
) > cleanupDocker.cmd

echo Creating initialrun.cmd...
(
echo @echo off
echo cls
echo echo ===============================================
echo echo Initial Run Script - Part of Docker LAMP Project
echo echo By Marcus Medina, 2024
echo echo Published under the MIT License
echo echo ===============================================
echo echo https://github.com/MarcusMedinaPro/DockerLamp
echo echo ===============================================
echo docker-compose build
echo start docker-compose up
echo echo ===============================================
) > initialrun.cmd

echo Docker Compose Configuration Created Successfully

echo.
echo Web Port: %WEB_PORT%
echo MySQL Database Name: %MYSQL_DATABASE%
echo MySQL User: %MYSQL_USER%
echo MySQL Root Password: %MYSQL_ROOT_PASSWORD%
echo MySQL Password: %MYSQL_PASSWORD%
echo phpMyAdmin Port: %PHPMYADMIN_PORT%
echo.
echo ===============================================

goto :eof

:eof
echo "Done!"
echo ===============================================
