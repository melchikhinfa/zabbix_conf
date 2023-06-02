#!/bin/bash
# Pre-config script for the bootstrap process

set_up() {
    # Set up the environment
    # This is where you would install any dependencies
    # that are required for the bootstrap process
    # to run successfully
    echo "=====Setting up the environment====="
    sudo apt update
    sudo apt install -y wget
    sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    
    echo "===== Installing openssh ====="
    sudo apt install -y openssh-server
    sudo systemctl enable ssh 
}

setup_root_login() {
    # Enable root login
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    sudo echo "root:rootroot" | chpasswd
}

zabbix_install() {
    # Install Zabbix v6.4 with PostgreSQL and nginx web server 
    echo "=====Installing Zabbix====="
    wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
    sudo dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
    sudo apt update
    sudo apt install -y zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent
}

firewall_setup(){
    # Implicating rules for Nginx and ssh
    sudo ufw enable
    sudo ufw allow 'OpenSSH'
    sudo ufw allow 'Nginx HTTP'
}

create_db() {
    echo "=====Creating database====="
    sudo apt  install -y postgresql
    sudo systemctl restart postgresql
    sudo -u postgres createuser --pwprompt zabbix
    sudo -u postgres createdb -O zabbix zabbix
    # Change the password for the zabbix user
    zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
    sudo sed 's/# DBPassword=/DBPassword=zabbix/gw' /etc/zabbix/zabbix_server.conf
}

main(){
    set_up
    setup_root_login
    zabbix_install
    firewall_setup
    create_db
}

main