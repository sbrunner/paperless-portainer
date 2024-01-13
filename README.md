# Paperless - Portainer

## Introduction

This project will provide an alternative way to install `paperless-ngx` with [Protainer](https://docs.portainer.io).

On a NAS it's difficult to install Paperless especially because we don't have `docker-compose`.
This repository provides some Docker compose files to be able to install easily install and maintain
Paperless on a NAS by using Portainer.

Those files contain everything Paperless needs to run.

## Install

1. On Portainer create a new stack.

2. Set a name.

3. Choose `Repository`.

4. Fill `Repository URL` with `https://github.com/sbrunner/paperless-portainer/`.

5. Fill `Compose path` with the path of the Docker compose file you want to use.

6. Select `Automatic updates` to be updated automatically (good for security but not for stability).

7. Click on `Deploy the stack`.

## Configuration

All the Paperless environment variable can be modified directly in Portainer.

## Database upgrades

### Configure

Configure the following environment variables:

    - `POSTGRES_UPGRADE_OLD_VOLUME`: Old database data folder.
    - `POSTGRES_UPGRADE_NEW_VOLUME`: New database data folder.
    - `POSTGRES_UPGRADE_OLD`: Old database version.
    - `POSTGRES_UPGRADE_NEW`: New database version.
    - `POSTGRES_UPGRADE_COMMAND`: should be set to `true`.

### Apply

1. Create a new folder for the new database data.

2. Update the environment variables:

    - `POSTGRES_UPGRADE_OLD_VOLUME` to the old folder
    - `POSTGRES_UPGRADE_NEW_VOLUME` ro the new folder
    - `POSTGRES_UPGRADE_OLD` to the old Postgres major version
    - `POSTGRES_UPGRADE_NEW` to the old Postgres major version.
    - `POSTGRES_UPGRADE_COMMAND` to `pg_upgrade; echo DONE; sleep infinity`.

3. Click on `Save settings`, then `Pull and redeploy`, wait that the composition is started.

4. Stop the `paperless-ngx-db-1` container.

5. Restart the `paperless-ngx-postgres-upgrade-1` container an what that you see the message `DONE` in the logs.

6. In the `paperless-ngx-postgres-upgrade-1` container run :

    - `/usr/lib/postgresql/${PG_MAJOR}/bin/vacuumdb --all --analyze-in-stages`
    - `cp ${PGDATAOLD}/pg_hba.conf ${PGDATANEW}/`.

7. Set the environment variables:

    - `POSTGRES_UPGRADE_COMMAND` to `true`.
    - `POSTGRES_DATA_VOLUME` to the new folder.

8. Click on `Save settings`, then `Pull and redeploy`, wait that the composition is started.

## Contributing

Install the pre-commit hooks:

```bash
pip install pre-commit
pre-commit install --allow-missing-config
```
