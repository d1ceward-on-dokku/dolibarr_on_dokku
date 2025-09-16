![](.github/images/repo_header.png)

[![Dolibarr](https://img.shields.io/badge/Dolibarr-22.0.1-blue.svg)](https://github.com/Dolibarr/dolibarr/releases/tag/22.0.1)
[![Dokku](https://img.shields.io/badge/Dokku-Repo-blue.svg)](https://github.com/dokku/dokku)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/d1ceward-on-dokku/dolibarr_on_dokku/graphs/commit-activity)

# Run Dolibarr on Dokku

## Overview

This guide explains how to deploy [Dolibarr](https://www.dolibarr.org/), a modern ERP and CRM software package, on a [Dokku](https://dokku.com/) host. Dokku is a lightweight PaaS that simplifies deploying and managing applications using Docker.

## Prerequisites

Before proceeding, ensure you have the following:

- A working [Dokku host](https://dokku.com/docs/getting-started/installation/).
- The [MariaDB plugin](https://github.com/dokku/dokku-mariadb) for database support.
- (Optional) The [Let's Encrypt plugin](https://github.com/dokku/dokku-letsencrypt) for SSL certificates.

## Setup Instructions

### 1. Create the App

Log into your Dokku host and create the `dolibarr` app:

```bash
dokku apps:create dolibarr
```

### 2. Configure the Database

Install, create, and link the MariaDB plugin to the app:

```bash
# Install MariaDB plugin
dokku plugin:install https://github.com/dokku/dokku-mariadb.git mariadb

# Create a MariaDB instance
dokku mariadb:create dolibarr

# Link the database to the app
dokku mariadb:link dolibarr dolibarr
```

### 3. Configure Persistent Storage

To persist uploaded data between restarts, create folders on the host machine and mount them to the app container:

```bash
# Documents directory
dokku storage:ensure-directory dolibarr-documents --chown false
dokku storage:mount dolibarr /var/lib/dokku/data/storage/dolibarr-documents:/var/www/documents

# Custom directory
dokku storage:ensure-directory dolibarr-custom --chown false
dokku storage:mount dolibarr /var/lib/dokku/data/storage/dolibarr-custom:/var/www/html/custom
```

### 4. Configure the Domain and Ports

Set the domain for your app to enable routing:

```bash
dokku domains:set dolibarr dolibarr.example.com
```

Map the internal port `80` to the external port `80`:

```bash
dokku ports:set grafana http:80:80
```

### 5. Deploy the App

You can deploy the app to your Dokku server using one of the following methods:

#### Option 1: Deploy Using `dokku git:sync`

If your repository is hosted on a remote Git server with an HTTPS URL, you can deploy the app directly to your Dokku server using `dokku git:sync`. This method also triggers a build process automatically. Run the following command:

```bash
dokku git:sync --build dolibarr https://github.com/d1ceward-on-dokku/dolibarr_on_dokku.git
```

#### Option 2: Clone the Repository and Push Manually

If you prefer to work with the repository locally, you can clone it to your machine and push it to your Dokku server manually:

1. Clone the repository:

    ```bash
    # Via SSH
    git clone git@github.com:d1ceward-on-dokku/dolibarr_on_dokku.git

    # Via HTTPS
    git clone https://github.com/d1ceward-on-dokku/dolibarr_on_dokku.git
    ```

2. Add your Dokku server as a Git remote:

    ```bash
    git remote add dokku dokku@example.com:dolibarr
    ```

3. Push the app to your Dokku server:

    ```bash
    git push dokku master
    ```

Choose the method that best suits your workflow.

### 6. Enable SSL (Optional)

Secure your app with an SSL certificate from Let's Encrypt:

1. Add the HTTPS port:

    ```bash
    dokku ports:add grafana https:443:9000
    ```

2. Install the Let's Encrypt plugin:

    ```bash
    dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
    ```

3. Set the contact email for Let's Encrypt:

    ```bash
    dokku letsencrypt:set dolibarr email you@example.com
    ```

4. Enable Let's Encrypt for the app:

    ```bash
    dokku letsencrypt:enable dolibarr
    ```

## Wrapping Up

Congratulations! Your Dolibarr instance is now up and running. You can access it at [https://dolibarr.example.com](https://dolibarr.example.com).

Happy managing!
