## Setup Instructions

1. Pull repository to your local working directory as a separate folder
2. Edit .env file and fill it with config data
3. Edit files in secrets folder and fill them with relevant values
4. Run install/add-hosts.sh to edit hosts file on Windows machine
5. Run install/create-cert.sh to create SSL certificate for local use
6. Run install/git-config.sh to add clean filter to prevent uploading .env and secrets to remote reepository 
7. Run "docker-compose up -d" from docker-wp-setup directory
