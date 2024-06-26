# Docker LAMP Stack on Windows

Welcome to my Docker LAMP stack setup! 🎉

As a .NET and Java teacher, I have a deep love for programming, but my heart always finds a way back to PHP. This setup is something I created to fuel my own hobby projects and I hope it inspires you to explore the world of PHP development as well.

## Why This Project?

Even though my day job involves teaching .NET and Java, I often find myself tinkering with PHP in my spare time. It's like a guilty pleasure that I just can't resist! To streamline my development process and make it easier to jump into coding, I decided to set up a Dockerized LAMP stack. This setup allows me to quickly spin up a development environment on my Windows machine and dive right into coding without any hassle.

I hope this setup makes your PHP development as enjoyable and productive as it has made mine. 

## Prerequisites

Before we get started, make sure you have the following installed:

- Docker Desktop for Windows
- Docker Compose

## Getting Started

### 1. Clone the Repository

First, clone the repository to your local machine:

```sh
git clone https://github.com/MarcusMedinaPro/DockerLamp.git
cd DockerLamp
```

### 2. Run the Setup Script

The `setup.cmd` script will guide you through creating a `docker-compose.yml` file and other necessary scripts. You'll need to provide some information like ports, database name, and user credentials.

```sh
setup [WEB_PORT] [MYSQL_DATABASE] [MYSQL_USER] [MYSQL_ROOT_PASSWORD] [MYSQL_PASSWORD] [PHPMYADMIN_PORT]
```

Example:

```sh
setup 8080 myDatabase dbUser rootPassword userPassword 8081
```

### 3. Build and Run the Docker Containers

Use the `build.cmd` script to build and start the Docker containers:

```sh
build
```

### 4. Access Your Services

Once everything is up and running, you can access the services at the following URLs:

- **Web Server:** [http://localhost:YOUR_WEB_PORT](http://localhost:YOUR_WEB_PORT)
- **phpMyAdmin:** [http://localhost:YOUR_PHPMYADMIN_PORT](http://localhost:YOUR_PHPMYADMIN_PORT)

## Scripts

To make your life easier, I've included a few scripts:

### `setup.cmd`

This script generates the `docker-compose.yml` file and other command scripts based on your inputs.

### `build.cmd`

Builds and starts the Docker containers.

### `run.cmd`

Starts the Docker containers if they are already built.

### `stop.cmd`

Stops the running Docker containers.

### `cleanupDocker.cmd`

This one is not created by the setup script. Cleans up Docker resources including stopping all running containers, removing unused volumes, networks, images, build cache, and system resources.

## Docker Compose Configuration

Here's a sneak peek at the `docker-compose.yml` that gets generated:

```yaml
services:
  web:
    image: php:8.2-apache
    container_name: ${COMPOSE_PROJECT_NAME}-web
    volumes:
      - ./src:/var/www/html
    ports:
      - "${WEB_PORT}:80"
    working_dir: /var/www/html
    networks:
      - ${COMPOSE_PROJECT_NAME}_network

  db:
    image: mysql:latest
    container_name: ${COMPOSE_PROJECT_NAME}-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - ${COMPOSE_PROJECT_NAME}_network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    container_name: ${COMPOSE_PROJECT_NAME}-phpmyadmin
    environment:
      PMA_HOST: db
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    restart: always
    ports:
      - "${PHPMYADMIN_PORT}:80"
    depends_on:
      - db
    networks:
      - ${COMPOSE_PROJECT_NAME}_network

networks:
  ${COMPOSE_PROJECT_NAME}_network:
    driver: bridge

volumes:
  db_data:
```

## Why You'll Love This Setup

- **Quick Start:** Get your LAMP stack up and running in minutes.
- **Customizable:** Easily change ports and credentials to fit your needs.
- **Convenient:** Includes scripts for building, running, stopping, and cleaning up your Docker environment.
- **Versatile:** Perfect for PHP hobby projects and experimenting with web development.

## License

This project is licensed under the MIT License.
