#!/bin/bash

# Проверяем что все файлы на месте
echo "=== Проверяем файлы в /etc/9hitsv3-linux64/ ==="
ls -la /etc/9hitsv3-linux64/

echo "=== Проверяем файлы в /etc/9hitsv3-linux64/config/ ==="
ls -la /etc/9hitsv3-linux64/config/

# Запускаем health server
start_health_server() {
    while true; do
        {
            echo -e "HTTP/1.1 200 OK\r\n"
            echo -e "Content-Type: text/plain\r\n"
            echo -e "Connection: close\r\n"
            echo -e "\r\n"
            echo -e "OK\r\n"
            echo -e "\r\n"
        } | nc -l -p 8000 -q 0 -w 1
    done
}

start_health_server &
sleep 5

echo "=== Запускаем 9hits ==="
./nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot
