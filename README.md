## Setup Instructions

1. Pull repository to your local machine
2. Edit .env file and fill it with config data
3. Run docker/cli/add-hosts.sh to edit hosts file on Windows machine
4. Run docker/cli/create-cert.sh to create SSL certificate for local use
5. Create docker/creds folder with following files containing relevant values:
   - db_name.txt
   - db_prefix.txt
   - db_user.txt
   - db_password.txt
6. Run docker-compose up -d
