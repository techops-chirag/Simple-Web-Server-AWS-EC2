#!/bin/bash

set -e

LOG_FILE=/var/log/infra_install.log

log() {
    local log_message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo . >> "$LOG_FILE"
    echo . >> "$LOG_FILE"
    echo "$timestamp - $log_message" >> "$LOG_FILE"
}

log "Update and install deps"
apt-get update && apt-get install -y gnupg software-properties-common curl ca-certificates gnupg lsb-release >> $LOG_FILE 2>&1

log "Seting up repos"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg >> $LOG_FILE 2>&1
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

log "Update deps"
apt-get update >> $LOG_FILE 2>&1

log "Docker is not working in the system. Checking..."
yes | apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin >> $LOG_FILE 2>&1
service docker start >> $LOG_FILE 2>&1
docker ps > /dev/null 2>&1
rc=$? 
if [[ $rc -ne 0 ]]; then
    log "A problem ocurred while trying to check the docker service running."
fi

log "Making host folder for Docker volume"
mkdir -p /var/www/html >> $LOG_FILE 2>&1
chmod 775 /var/www/html >> $LOG_FILE 2>&1

log "Runing Docker container for nginx"
docker run --name some-nginx -d -p 80:80 -v /var/www/html:/usr/share/nginx/html --restart=always nginx >> $LOG_FILE 2>&1

log "Creating index.html"
hostname=`hostname` >> $LOG_FILE 2>&1
echo "The page came from the hostname ${hostname}" | sudo tee /var/www/html/index.html >> $LOG_FILE 2>&1

log "Copying log for download"
sudo cp $LOG_FILE /var/www/html/install.log