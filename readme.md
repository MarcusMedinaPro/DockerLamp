# Docker LAMP Stack

Welcome to my Docker LAMP stack setup! 🎉

As a .NET and Java teacher, I have a deep love for programming, but my heart always finds a way back to PHP. This setup is something I created to fuel my own hobby projects and I hope it inspires you to explore the world of PHP development as well.

## Why This Project?

Even though my day job involves teaching .NET and Java, I often find myself tinkering with PHP in my spare time. It's like a guilty pleasure that I just can't resist! To streamline my development process and make it easier to jump into coding, I decided to set up a Dockerized LAMP stack. This setup allows me to quickly spin up a development environment and dive right into coding without any hassle — on Windows, macOS, or Linux.

I hope this setup makes your PHP development as enjoyable and productive as it has made mine.

## Prerequisites

Before we get started, make sure you have the following installed:

- Docker Desktop (or Docker Engine on Linux)
- Docker Compose v2 (bundled with Docker Desktop and recent Docker Engine installs; the `docker compose` command, not the older `docker-compose`)

## Getting Started

### 1. Clone the Repository

```sh
git clone https://github.com/MarcusMedinaPro/DockerLamp.git
cd DockerLamp
```

### 2. Create your `.env`

Either copy the template by hand:

```sh
cp .env-example .env
```

...or use the setup script for your platform, which fills in ports/credentials for you:

```sh
# Windows
setup [WEB_PORT] [MYSQL_DATABASE] [MYSQL_USER] [MYSQL_ROOT_PASSWORD] [MYSQL_PASSWORD] [PHPMYADMIN_PORT]

# Linux / macOS
./setup.sh [WEB_PORT] [MYSQL_DATABASE] [MYSQL_USER] [MYSQL_ROOT_PASSWORD] [MYSQL_PASSWORD] [PHPMYADMIN_PORT]
```

Example:

```sh
setup 8080 myDatabase dbUser rootPassword userPassword 8081
```

`docker-compose.yml` and the Dockerfile are static and committed — the setup
script only ever writes `.env`, it never touches them.

### 3. Build and Run the Docker Containers

```sh
# Windows
build

# Linux / macOS
./build.sh
```

### 4. Access Your Services

Once everything is up and running, you can access the services at the following URLs:

- **Web Server:** [http://localhost:YOUR_WEB_PORT](http://localhost:YOUR_WEB_PORT)
- **phpMyAdmin:** [http://localhost:YOUR_PHPMYADMIN_PORT](http://localhost:YOUR_PHPMYADMIN_PORT)

## Scripts

Every script comes in a `.cmd` (Windows) and `.sh` (Linux/macOS) flavor with
identical behavior.

### `setup` / `setup.sh`

Writes `.env` based on your inputs (or `default` / `marcus` presets).

#### Command Line Arguments

- **WEB_PORT:** The port number for the web server.
- **MYSQL_DATABASE:** The name of the MySQL database.
- **MYSQL_USER:** The MySQL user name.
- **MYSQL_ROOT_PASSWORD:** The MySQL root password.
- **MYSQL_PASSWORD:** The MySQL user password.
- **PHPMYADMIN_PORT:** The port number for phpMyAdmin.

#### Other commands

- **help:** Displays the help message (reads current values from `.env`).
- **version:** Displays script and Docker version info.
- **cleanup:** Removes `.env` and Docker resources for this project.
- **default:** Generates `.env` with default settings.

### `build` / `build.sh`

Builds the Docker images.

### `run` / `run.sh`

Starts the containers (detached).

### `stop` / `stop.sh`

Stops the running containers.

### `test` / `test.sh`

Runs the PHPUnit test suite in a disposable container.

### `cleanupDocker` / `cleanupDocker.sh`

Stops containers and prunes unused Docker volumes, networks, images, and
build cache.

### `initialrun` / `initialrun.sh`

Builds and starts the containers in one step.

## Stack Versions

Image versions are pinned directly in `Dockerfile` and `docker-compose.yml`
(currently PHP 8.4, MySQL 8.4 LTS, phpMyAdmin 5.2). Dependabot watches both
files and opens PRs when newer versions are available — see
[CHANGELOG.md](CHANGELOG.md) for the version history.

## Data Persistence

MySQL data lives in the named Docker volume `db_data`, so your database
survives `stop`/`run` cycles. Composer's `vendor/` directory lives in its own
named volume (`vendor_data`) rather than being bind-mounted from the host, so
packages installed at build time aren't wiped out at runtime.

## Why You'll Love This Setup

- **Quick Start:** Get your LAMP stack up and running in minutes.
- **Cross-Platform:** Works the same way on Windows, macOS, and Linux.
- **Customizable:** Easily change ports and credentials via `.env`.
- **Convenient:** Includes scripts for building, running, stopping, testing, and cleaning up your Docker environment.
- **Versatile:** Perfect for PHP hobby projects and experimenting with web development.

## Feedback

If you have any feedback or suggestions, send a message through Github or create an issue or a pull-request.

I'd love to hear from you!

## Contributing

If you'd like to contribute to this project, feel free to fork the repository and submit a pull request. I'd be happy to review and merge your changes.

## License

This project is licensed under the MIT License.
