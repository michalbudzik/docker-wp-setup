# Docker Wordpress Setup for local work

## Decription

I needed a quick setup allowing me to work locally on Wordpress projects. After reading and watching a ton of tutorials I managed to compile all that new knowledge into a working repo you can simply pull and start using. Most of the magic happens in docker-coompose.yml file. It runs six containers:
- nginx server (to allow local ssl certificates and domain mapping)
- MariaDB database (or MySQL or any other system you prefer) 
- phpMyAdmin (for some manual database manipulation through gui, adminer should work too)
- Wordpress with chosen PHP version (obviously)
- WP-CLI (to allow command line control if needed)
- MailHog SMTP server (for testing e-mails sent by Wordpress)

It also creates two named volumes for Wordpress Core files and the database. They won't be visible on your system but all the data will persist between container restarts. Probably there are some use cases when you actually need local access to Wordpress core files, but usually all the work happens inside wp-content folder. At first I wanted to bind mount it as a whole, but finally for hygiene's sake I decided to mount only its four subdirectories:
- mu-plugins
- plugins
- themes
- uploads

This way I don't have to watch empty index.php and upgrade folder all the time. It's just cleaner this way.

## Install Instructions

1. Pull repository to your local working directory as a separate folder
2. Edit .env file and fill it with config data
3. Edit files in secrets folder and fill them with relevant values
4. Run install/add-hosts.sh to edit hosts file on Windows machine
5. Run install/create-cert.sh to create SSL certificate for local use
6. Run install/git-config.sh to add clean filter to prevent uploading .env and secrets to remote reepository 
7. Run "docker-compose up -d" from docker-wp-setup directory
