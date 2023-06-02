# Установка Zabbix с Nginx и PostgreSQL на Ubuntu 22.04

Этот гайд поможет вам установить Zabbix с Nginx и PostgreSQL на Ubuntu 22.04. 

## Требования

- Ubuntu 22.04
- Доступ к серверу с правами суперпользователя (root)
- Установленный и настроенный Nginx
- Установленный и настроенный PostgreSQL

## Установка Zabbix

### Шаг 1: Добавление репозитория Zabbix

Для начала, нужно добавить репозиторий Zabbix в систему. Для этого откройте терминал и выполните следующие команды:

```bash
wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_5.4-1+ubuntu22.04_all.deb
```

### Шаг 2: Установка Zabbix Server и Zabbix Agent

Теперь можно установить Zabbix Server и Zabbix Agent, используя следующую команду:

```bash
sudo apt-get update
sudo apt-get install zabbix-server-pgsql zabbix-frontend-php zabbix-apache-conf zabbix-agent
```

### Шаг 3: Создание базы данных для Zabbix

Теперь нужно создать базу данных для Zabbix. Для этого выполните следующие команды:

```bash
sudo su - postgres
psql
CREATE DATABASE zabbix;
CREATE USER zabbix WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
\q
exit
```

### Шаг 4: Настройка Zabbix Server

Откройте файл конфигурации Zabbix Server и измените следующие параметры:

```bash
sudo nano /etc/zabbix/zabbix_server.conf
```

```bash
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=password
```

### Шаг 5: Настройка Zabbix Agent

Откройте файл конфигурации Zabbix Agent и измените следующие параметры:

```bash
sudo nano /etc/zabbix/zabbix_agentd.conf
```

```bash
Server=127.0.0.1
ServerActive=127.0.0.1
Hostname=Zabbix server
```

### Шаг 6: Настройка Nginx

Откройте файл конфигурации Nginx и добавьте следующие строки:

```bash
sudo nano /etc/nginx/sites-available/default
```

```bash
server {
    listen       80;
    server_name  example.com;

    access_log  /var/log/nginx/access.log;

    location / {
        root   /usr/share/zabbix;
        index  index.php index.html index.htm;
    }

    location ~ \.php$ {
        fastcgi_pass   unix:/run/php/php7.4-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```

### Шаг 7: Перезапуск служб

Перезапустите службы Zabbix, Nginx и PHP-FPM:

```bash
sudo systemctl restart zabbix-server zabbix-agent nginx php7.4-fpm
```

### Шаг 8: Завершение установки

Теперь можно открыть браузер и зайти на страницу http://example.com/zabbix, где example.com - ваш домен или IP-адрес сервера. После этого следуйте инструкциям на экране для завершения установки.

Готово! Теперь вы успешно установили Zabbix с Nginx и PostgreSQL на Ubuntu 22.04.