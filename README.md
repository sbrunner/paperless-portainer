# Paperless - Portainer

## Introduction

This project provides an alternative way to install `paperless-ngx` with [Portainer](https://docs.portainer.io).

On a NAS, it's difficult to install Paperless, especially because we don't have `docker-compose`.
This repository provides Docker compose files to easily install and maintain Paperless on a NAS using Portainer.

These files contain everything Paperless needs to run.

## Install

1. In Portainer, create a new stack.

2. Set a name.

3. Choose `Repository`.

4. Fill `Repository URL` with `https://github.com/sbrunner/paperless-portainer/`.

5. Fill `Compose path` with the path of the Docker compose file you want to use.

6. Select `Automatic updates` to be updated automatically (good for security but not for stability).

7. Click on `Deploy the stack`.

## Configuration

All the Paperless environment variables can be modified directly in Portainer.

## Database Upgrades

### Configure

Set the following environment variables:

- `POSTGRES_UPGRADE_OLD_VOLUME`: Old database data folder.
- `POSTGRES_UPGRADE_NEW_VOLUME`: New database data folder.
- `POSTGRES_UPGRADE_OLD`: Old database version.
- `POSTGRES_UPGRADE_NEW`: New database version.

### Apply

1. Create a new folder for the new database data.

2. Update the environment variables:
    - `POSTGRES_UPGRADE_OLD_VOLUME` to the old folder.
    - `POSTGRES_UPGRADE_NEW_VOLUME` to the new folder.
    - `POSTGRES_UPGRADE_OLD` to the old Postgres major version.
    - `POSTGRES_UPGRADE_NEW` to the new Postgres major version.
    - `POSTGRES_DATA_VOLUME` to the new Postgres major version.

3. Click on `Save settings`, then `Pull and redeploy`, and wait for the composition to start.

4. Stop the `paperless-ngx-paperless-1` container.

5. Stop the `paperless-ngx-db-1` container.

6. In the `paperless-ngx-postgres-upgrade-1` container, run the following commands:
    - `apt update && apt install sudo`
    - `sudo -E -u postgres /usr/lib/postgresql/${PG_MAJOR}/bin/pg_upgrade`
    - `cp ${PGDATAOLD}/pg_hba.conf ${PGDATANEW}/`

7. Start the `paperless-ngx-db-1` and `paperless-ngx-paperless-1` containers.

## Contributing

Install the pre-commit hooks:

```bash
pip install pre-commit
pre-commit install --allow-missing-config
```
