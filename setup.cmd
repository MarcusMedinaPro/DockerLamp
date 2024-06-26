@echo off
setlocal

if "%1"=="help" goto :help
if "%1"=="" goto :usage
if "%6"=="" goto :usage

set WEB_PORT=%1
set MYSQL_DATABASE=%2
set MYSQL_USER=%3
set MYSQL_ROOT_PASSWORD=%4
set MYSQL_PASSWORD=%5
set PHPMYADMIN_PORT=%6

rem Delete existing files
if exist docker-compose.yml del docker-compose.yml
if exist build.cmd del build.cmd
if exist run.cmd del run.cmd
if exist stop.cmd del stop.cmd

echo Creating docker-compose.yml...
(
echo services:
echo   web:
echo     build: .
echo     ports:
echo       - "%WEB_PORT%:80"
echo     volumes:
echo       - ./public:/var/www/html
echo     environment:
echo       MYSQL_ROOT_PASSWORD: %MYSQL_ROOT_PASSWORD%
echo       MYSQL_DATABASE: %MYSQL_DATABASE%
echo       MYSQL_USER: %MYSQL_USER%
echo       MYSQL_PASSWORD: %MYSQL_PASSWORD%
echo   db:
echo     image: mysql:latest
echo     restart: always
echo     environment:
echo       MYSQL_ROOT_PASSWORD: %MYSQL_ROOT_PASSWORD%
echo       MYSQL_DATABASE: %MYSQL_DATABASE%
echo       MYSQL_USER: %MYSQL_USER%
echo       MYSQL_PASSWORD: %MYSQL_PASSWORD%
echo     volumes:
echo       - db_data:/var/lib/mysql
echo   phpmyadmin:
echo     image: phpmyadmin:latest
echo     restart: always
echo     ports:
echo       - "%PHPMYADMIN_PORT%:80"
echo     environment:
echo       PMA_HOST: db
echo       MYSQL_ROOT_PASSWORD: %MYSQL_ROOT_PASSWORD%
echo volumes:
echo   db_data:
) > docker-compose.yml

echo Creating build.cmd...
(
echo @echo off
echo docker-compose build
echo.
echo You can now use run.cmd to start using the docker image
) > build.cmd

echo Creating run.cmd...
(
echo @echo off
echo docker-compose up
) > run.cmd

echo Creating stop.cmd...
(
echo @echo off
echo docker-compose down
) > stop.cmd

echo Docker Compose Configuration Created Successfully

echo.
echo Web Port: %WEB_PORT%
echo MySQL Database Name: %MYSQL_DATABASE%
echo MySQL User: %MYSQL_USER%
echo MySQL Root Password: %MYSQL_ROOT_PASSWORD%
echo MySQL Password: %MYSQL_PASSWORD%
echo phpMyAdmin Port: %PHPMYADMIN_PORT%

goto :eof

:usage
echo Usage: setup [WEB_PORT] [MYSQL_DATABASE] [MYSQL_USER] [MYSQL_ROOT_PASSWORD] [MYSQL_PASSWORD] [PHPMYADMIN_PORT]
goto :eof

:help
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
echo.
echo You can now use build.cmd to start building the docker image

rem Add genereated files to .gitignore (if they don't already exist)
if not exist .gitignore echo docker-compose.yml> .gitignore
if not exist .gitignore echo build.cmd>> .gitignore
if not exist .gitignore echo run.cmd>> .gitignore
if not exist .gitignore echo stop.cmd>> .gitignore

goto :eof
