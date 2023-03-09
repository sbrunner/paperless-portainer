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

6. Click on `Deploy the stack`.

## Configuration

All the Paperless environment variable can be modified directly in Portainer.

## Database upgrades

1. Create a new folder for the new database data.

2. Configure the following environment variables:

    - `POSTGRES_UPGRADE_OLD_VOLUME`: Old database data folder.
    - `POSTGRES_UPGRADE_NEW_VOLUME`: New database data folder.
    - `POSTGRES_UPGRADE_OLD`: Old database version.
    - `POSTGRES_UPGRADE_NEW`: New database version.
    - `POSTGRES_UPGRADE_COMMAND`: should be set to `pg_upgrade`.

3. Upgrade the composition

4. Stop the `db` service and start the `postgres-upgrade` service.

5. Wait for the upgrade to finish.

6. Set the `POSTGRES_UPGRADE_COMMAND` environment variable to `true`.

7. Copy the `pg_hba.conf` file from the old database data folder to the new database data folder.

8. Start the `db` service.
