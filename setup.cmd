@echo off
setlocal enabledelayedexpansion

set VERSION_SETUP=2.0.0

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

goto :write_env

:default
echo Setting up for Default...
set WEB_PORT=8080
set MYSQL_DATABASE=db%CURRENT_FOLDER%
set MYSQL_USER=User
set MYSQL_ROOT_PASSWORD=adminpassword
set MYSQL_PASSWORD=password
set PHPMYADMIN_PORT=8081
goto :write_env

:marcus
echo Setting up for Marcus...
echo Hello Marcus!
set WEB_PORT=8192
set MYSQL_DATABASE=db%CURRENT_FOLDER%
set MYSQL_USER=Marcus
set MYSQL_ROOT_PASSWORD=kattskit
set MYSQL_PASSWORD=kattskit
set PHPMYADMIN_PORT=8193
goto :write_env

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

if exist .env del .env

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
echo Setup: %VERSION_SETUP%
echo ===============================================
echo Image versions are pinned in Dockerfile / docker-compose.yml
echo See CHANGELOG.md for the current stack version history.
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
echo Reading credentials from .env...
for /f "tokens=2 delims==" %%i in ('findstr WEB_PORT .env') do set WEB_PORT=%%i
for /f "tokens=2 delims==" %%i in ('findstr MYSQL_DATABASE .env') do set MYSQL_DATABASE=%%i
for /f "tokens=2 delims==" %%i in ('findstr MYSQL_USER .env') do set MYSQL_USER=%%i
for /f "tokens=2 delims==" %%i in ('findstr MYSQL_ROOT_PASSWORD .env') do set MYSQL_ROOT_PASSWORD=%%i
for /f "tokens=2 delims==" %%i in ('findstr /b MYSQL_PASSWORD .env') do set MYSQL_PASSWORD=%%i
for /f "tokens=2 delims==" %%i in ('findstr PHPMYADMIN_PORT .env') do set PHPMYADMIN_PORT=%%i

echo.
echo Web Port: %WEB_PORT%
echo MySQL Database Name: %MYSQL_DATABASE%
echo MySQL User: %MYSQL_USER%
echo MySQL Root Password: %MYSQL_ROOT_PASSWORD%
echo MySQL Password: %MYSQL_PASSWORD%
echo phpMyAdmin Port: %PHPMYADMIN_PORT%
echo ===============================================
echo use build.cmd to build the docker image
echo use run.cmd to start the docker image
echo or use initialrun.cmd to build and start (lazy, lol)
echo use stop.cmd to stop the docker image
echo use test.cmd to run the test suite
echo use cleanupDocker.cmd to remove docker resources
echo ===============================================
goto :eof

:write_env
(
echo WEB_PORT=%WEB_PORT%
echo MYSQL_DATABASE=%MYSQL_DATABASE%
echo MYSQL_USER=%MYSQL_USER%
echo MYSQL_ROOT_PASSWORD=%MYSQL_ROOT_PASSWORD%
echo MYSQL_PASSWORD=%MYSQL_PASSWORD%
echo PHPMYADMIN_PORT=%PHPMYADMIN_PORT%
) > .env

echo .env created successfully

echo.
echo Web Port: %WEB_PORT%
echo MySQL Database Name: %MYSQL_DATABASE%
echo MySQL User: %MYSQL_USER%
echo MySQL Root Password: %MYSQL_ROOT_PASSWORD%
echo MySQL Password: %MYSQL_PASSWORD%
echo phpMyAdmin Port: %PHPMYADMIN_PORT%
echo.
echo ===============================================
echo Next: run build.cmd, then run.cmd
echo ===============================================
goto :eof

:eof
echo Done!
echo ===============================================
