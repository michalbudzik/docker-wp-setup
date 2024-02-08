# Docker Wordpress Setup for local development

## Overview

I needed a quick `Docker` setup allowing me to work locally on `Wordpress` projects. After reading and watching a ton of tutorials I managed to compile all that new knowledge into a working repository you can simply pull and start using. The main workflow idea is like this:

1. copy all necessary files into project's subdirectory on your drive
2. fill project's data
3. run few needed `bash` scripts
4. run `Docker` containers
5. start working on live local `Wordpress` install with access to `WP-CLI`, `phpMyAdmin`and `MailHog` `SMTP` server  

## Install Instructions

1. Clone repository to your local working directory as a separate folder
2. Edit `.env` file and fill it with config data
3. Edit files in `secrets` folder and fill them with relevant values
4. Run `install/add-hosts.sh` to edit `hosts` file on `Windows` machine
5. Run `install/create-cert.sh` to create `SSL` certificate for local use
6. Run `install/git-config.sh` to add `clean` filter to prevent uploading .env and secrets to remote reepository 
7. Run `Docker` containers from `docker-wp-setup` directory:

   ```bash
   docker-compose up -d
   ```

## Requirements

- Docker
- GIT Bash
- mkcert
- gsudo

## Detailed decription

### Containers

Most of the magic happens in `docker-coompose.yml` file. Executing it runs six containers:

- `nginx` server (to allow local `SSL` certificates and domain mapping)
- `MariaDB` database (or `MySQL` or any other system you prefer) 
- `phpMyAdmin` (for some manual database manipulation through gui, `adminer` should work too)
- `Wordpress` with chosen PHP version (obviously)
- `WP-CLI` (to allow command line control if needed)
- `MailHog` SMTP server (for testing e-mails sent by Wordpress)

### Volumes and Bind Mounts

Running `docker-coompose.yml` also creates two named volumes for `Wordpress Core` files and the database. They won't be visible on the local file system but all the data will persist between containers restarts. Probably there are some use cases when you would actually need local access to `Wordpress Core` files, but usually all the work happens inside `wp-content` folder. At first I wanted to bind mount it as a whole, but finally for hygiene's sake I decided to mount only its four subdirectories:

- `mu-plugins`
- `plugins`
- `themes`
- `uploads`

This way I don't have to watch empty `index.php` and `upgrade` folder all the time. It's just cleaner this way.

There are also some additional bind mounts for server config files, logs and `SSL`:

- `nginx/default.conf.conf` for: 
   - `SSL` and local domain configuration (no need to meddle there)
   - changing `client_max_body_size` value to allow bigger file uploads in `Wordpress`
- `config/php.ini` for typical `PHP` settings
- `config/phpmyadmin.ini` for bigger file uploads in `phpMyAdmin`
- `logs` for logging server errors to file
- `certs` to load local `SSL` certificates into server 

### Environment variables and secrets

Apparently it's a bad practice to hold credentials or other secrets as environment variables hence the `secrets` folder. There are four `.txt` files there, each for a single variable. They are all needed for `Wordpress` database to work. Each file should include only a single secret value corresponding with the filename. No quotes, no double quotes, just value. 

This way `.env` file contains only project's name for a few different display slots in `Docker`, `IP` address and local domain.

`install/git-config.sh` executed during install process makes sure that local `.gitconfig` is being loaded by `GIT`. `.gitconfig` and `.gitattributes` (loaded automatically) define two `clean` filters that accordingly truncate `.env` and files from `secrets` folder removing any sensitive data while pushing repo back to origin.

One could argue that all those layers of security are rather pointless here, especially considering that database credentials are for local purposes only and in no way connected with the actual live website online, but in case of developing this setup a little further one might realize that suddenly his login data is available for everyone. So let's keep it clean.  

### SSL Certificate and local domain 

- mkcert
- certs directory
- Firefox fix

### File Structure and Git workflow
- separate subfolder for setup
- .gitignore
- setup as submodule