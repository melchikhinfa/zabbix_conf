# Установка Zabbix Proxy

## Требования

- Ubuntu 22.04 на машине, где будет установлен Zabbix Proxy
- Доступ к серверу с правами суперпользователя (root)
- Установленный и настроенный Zabbix Server

## Установка Zabbix Proxy

### Шаг 1: Добавление репозитория Zabbix

Для начала, нужно добавить репозиторий Zabbix в систему. Для этого откройте терминал и выполните следующие команды:

```bash
wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_5.4-1+ubuntu22.04_all.deb
```

### Шаг 2: Установка Zabbix Proxy

Теперь можно установить Zabbix Proxy, используя следующую команду:

```bash
sudo apt-get update
sudo apt-get install zabbix-proxy-pgsql
```

### Шаг 3: Настройка Zabbix Proxy

Откройте файл конфигурации Zabbix Proxy и измените следующие параметры:

```bash
sudo nano /etc/zabbix/zabbix_proxy.conf
```

```bash
Server=<IP адрес или доменное имя сервера с Zabbix Server>
Hostname=<имя хоста>
DBName=zabbix
DBUser=zabbix
DBPassword=<пароль для пользователя zabbix>
```

### Шаг 4: Настройка файрвола

Если у вас есть настроенный файрвол, то нужно открыть порты для Zabbix Proxy. Для PostgreSQL это порт 5432, а для Zabbix Proxy - порты 10051 и 10052.

### Шаг 5: Перезапуск служб

Перезапустите службы Zabbix Proxy:

```bash
sudo systemctl restart zabbix-proxy
```

### Шаг 6: Проверка подключения

Откройте веб-интерфейс Zabbix Server и перейдите на страницу "Configuration" -> "Proxy". 