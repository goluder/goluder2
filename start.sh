#!/bin/bash

# Запускаем health server (для проверки что все работает)
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

# Запускаем health server в фоне
start_health_server &

# Ждем 5 секунд чтобы все успело запуститься
sleep 5

# Запускаем основную программу 9hits
./nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot