setup(){
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

zabbix_proxy_db_install() {
    # Install Zabbix with PostgreSQL proxy
    echo "=====Installing Zabbix====="
    sudo apt  install -y postgresql
    sudo systemctl restart postgresql
    wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
    sudo dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
    sudo apt update
    sudo apt install -y zabbix-proxy-pgsql zabbix-sql-scripts
}

firewall(){
    sudo ufw enable
    sudo ufw allow 5433/tcp
    sudo ufw allow 'OpenSSH'
    sudo ufw reload
}

main(){
    setup
    setup_root_login
    zabbix_proxy_db_install
    firewall
}

main