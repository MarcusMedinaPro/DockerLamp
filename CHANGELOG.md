# Changelog

All notable changes to this project are documented in this file.

## [1.0.0] - 2026-09-11

### Added
- Committed `docker-compose.yml` and `.env-example` as the single source of
  truth for stack versions and configuration (previously generated on the fly
  by `setup.cmd`, which meant Dependabot and diffs never saw them).
- `.github/dependabot.yml` to track Docker base image updates automatically.
- Cross-platform `.sh` scripts (`setup.sh`, `build.sh`, `run.sh`, `stop.sh`,
  `test.sh`, `cleanupDocker.sh`, `initialrun.sh`) alongside the existing
  `.cmd` scripts, for Linux/macOS use.
- Named volume for Composer's `vendor/` directory.

### Changed
- Updated PHP to 8.4.25, MySQL to 8.4.11 (LTS), phpMyAdmin to 5.2.3.
- Switched all scripts from the legacy `docker-compose` CLI to `docker compose`
  (Compose v2).
- `setup.cmd` / `setup.sh` now only generate `.env`; the compose file and
  wrapper scripts are static and committed.

### Fixed
- Composer's installed `vendor/` directory was being shadowed by an empty
  bind-mounted host folder, which silently broke `test.cmd`/`test.sh`.
