# Docker Wordpress Setup for Local Development

## Overview

I needed a quick `Docker` setup allowing me to work locally on `Wordpress` projects. After reading and watching a ton of tutorials I managed to compile all that new knowledge into a working repository you can simply pull and start using. The main workflow idea is like this:

1. copy all necessary files into project's subdirectory on your drive
2. fill project's data
3. run few needed `bash` scripts
4. run `Docker` containers
5. start working on live local `Wordpress` install with access to `WP-CLI`, `phpMyAdmin`and `MailHog` `SMTP` server  

## Requirements

- [`GIT`](https://git-scm.com/downloads) (actually not necessary for most of it to work, but surely helpful)
- [`Docker`](https://www.docker.com/products/docker-desktop/) (creates 'virtual machine like' containers on your system)
- [`mkcert`](https://mkcert.dev) (generates local `SSL` certificates)
- [`gsudo`](https://gerardog.github.io/gsudo) (allows running bash scripts with elevated privileges on `Windows` machine)
- [`Visual Studio Code`](https://code.visualstudio.com/) (or any other code editor you prefer)

## Install Instructions

1. Clone repository to your local working directory as a separate folder:

   ```bash
   git clone https://github.com/michalbudzik/docker-wp-setup
   ```

2. Navigate to `docker-wp-setup` folder, edit `.env` file and fill it with config data:

   ```bash
   cd docker-wp-setup
   code .env
   ```

3. Edit files in `secrets` folder and fill them with relevant values:

   ```bash
   code secrets/*
   ```

4. Run `install/_install.sh` to run necessary scripts:

   - `add-hosts.sh` to edit `hosts` file on `Windows` machine
   - `create-cert.sh` to create `SSL` certificate for local use
   - `git-config.sh` to add `clean` filter to prevent uploading `.env` and secrets to remote repository  
     
   ```bash
   cd install
   bash install.sh
   cd ..
   ```

5. Make sure `Docker` is active and Run `Docker` containers from `docker-wp-setup` directory:

   ```bash
   docker-compose up -d
   ```

## Detailed Decription

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
- `logs` for logging server errors to file (by default added to `.gitignore` file)
- `certs` to load local `SSL` certificates into server 

### Environment Variables and Secrets

Apparently it's a bad practice to hold credentials or other secrets as environment variables hence the `secrets` folder. There are four `.txt` files there, each for a single variable. They are all needed for `Wordpress` database to work. Each file should include only a single secret value corresponding with the filename. No quotes, no double quotes, just value. 

This way `.env` file contains only project's name for a few different display slots in `Docker`, `IP` address and local domain.

`install/git-config.sh` executed during setup process makes sure that local `.gitconfig` is being loaded by `GIT`. `.gitconfig` and `.gitattributes` (loaded automatically) define two `clean` filters that accordingly truncate `.env` and files from `secrets` folder removing any sensitive data while pushing repo back to origin.

One could argue that all those layers of security are rather pointless here, especially considering that database credentials are for local purposes only and in no way connected with the actual live website online, but in case of developing this setup a little further one might realize that suddenly his login data is available for everyone. So let's keep it clean.  

### SSL Certificate and Local Domain 

Responsible for creating `SSL` certificate for your local domain set in `.env` file is `mkcert` library. It automatically creates necessary files during the setup process and saves them in `certs` folder. They are at once recognized by your browser thanks to `nginx/default.conf.conf` file resulting in a safe connection. Or at least they should. In `Firefox` one more step might be needed. On `about:config` settings page you have to set `security.enterprise_roots.enabled` to `true` and that should do the trick. `certs` folder is by default added to `.gitignore` file as its contents are in no way needed anywhere online.  

### Usage, Folder Structure, Git Workflow

Once you successfully run `Docker` containers you can leave `docker-wp-setup` folder and actually kinda forget about it. If everything is working fine, the only time you need to get back here is to turn off your containers or run them again. Treat it as an on/off switch. To me it was essential here to fully isolate all setup files from actual work happening in `wp-content` in main project directory. Also if you're gonna sync your `Wordpress` project with remote `GIT` repository it might be a good idea to put `docker-wp-setup` folder in `.gitignore` file as those `clean` filters mentioned before are not gonna work from parent directory by default and you'll wind up with your passwords available online. There is a possibility to use `docker-wp-setup` as a submodule but it would need editing `.git/config` file in parent directory and it gets pretty complicated altogether as you shouldn't sync `.git` folder with your remote repository.  

After install process your project directory should look like this. Oh, there hopefully won't be `logs` catalog as it's being created when `Wordpress` encounters its first error. 

```bash
.
├── docker-wp-setup
│   ├── certs
│   ├── config
│   ├── filters
│   ├── install
│   ├── logs
│   ├── nginx
│   └── secrets
└── wp-content
    ├── mu-plugins
    ├── plugins
    ├── themes
    └── uploads
```

### Access Points

Apart from `WP-CLI` run by command line there are three main access points to your local website environment:
- `Wordpress` should be up and running on `https://DOMAIN` or `IP` set in `.env` file
- `phpMyAdmin` is available by `IP:8081`
- `MailHog` `UI` is working on `IP:8025` (just remember to configure `SMTP` on you theme or plugin)

## Acknowledgments

I'm in no way any kind of pro when it comes to `Docker` so to make it all work I had to dig through quite a lot of blogs, forums and `Stack Overflow` discussions. Resources below are those who happened to be most useful while preparing this repository:

- @aplauche: [`Docker`/`Wordpress` setup that was the great starting code base for this repo](https://github.com/aplauche/docker-wordpress-local)
- @joshmoto: [Repo with very good complete `Docker`/`Wordpress` setups collection for different scenarios](https://github.com/joshmoto/docker-wordpress-meetup-demo)
- bonnick.dev: [Very helpful `Docker`/`Wordpress` setup with detailed instructions for using it with `MailHog`](https://bonnick.dev/posts/developing-wordpress-with-docker)
- spacelift.io: [`Docker` `Secrets` explained](https://spacelift.io/blog/docker-secrets)
- objectpartners.com: [Detailed explanation of `Docker`/`Wordpress` setup with `WP-CLI` container & proxy config](https://objectpartners.com/2020/09/01/local-wordpress-development-with-docker/)
- zerowp.com: [`Docker`/`Wordpress` setup with `docker-compose.yml` focused on `WP-CLI` configuration](https://zerowp.com/wordpress-and-docker/)




