# ИСХОДНЫЙ ОБРАЗ: Укажите базовый образ, который использует Sliplane (напр., Debian или Ubuntu)
# Если вы используете '9hitste/app:latest', начните с него.
FROM 9hitste/app:latest

# 1. Установите необходимые утилиты
# Объединяем 'apt-get update' и 'install' в одну команду для оптимизации размера слоя
RUN apt-get update && \
    apt-get install -y wget tar netcat-openbsd bash && \
    rm -rf /var/lib/apt/lists/*

# 2. ПОДГОТОВКА КОНФИГУРАЦИИ
# Создаем целевую директорию
RUN mkdir -p /etc/9hitsv3-linux64/config/

# Загружаем, распаковываем и копируем конфиги
# Все шаги в одном слое для надежности
RUN wget -q -O /tmp/main.tar.gz https://github.com/atrei73/9hits-project/archive/main.tar.gz && \
    tar -xzf /tmp/main.tar.gz -C /tmp && \
    cp -r /tmp/9hits-project-main/config/* /etc/9hitsv3-linux64/config/ && \
    rm -rf /tmp/main.tar.gz /tmp/9hits-project-main

# Устанавливаем порт по умолчанию, который будет прослушиваться
ENV PORT 8000
EXPOSE 8000

# 3. КОМАНДА ЗАПУСКА
# Используем команду CMD для запуска приложения.
# Запускаем скрипт Health Check и ваш основной скрипт в фоне,
# а 'tail -f /dev/null' удерживает контейнер.
CMD bash -c " \
    # Запускаем Health Check в фоне \
    while true; do echo -e 'HTTP/1.1 200 OK\r\n\r\nOK' | /usr/bin/nc -l -p ${PORT} -q 0 -w 1; done & \
    \
    # Запускаем основной скрипт в фоне \
    /nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot --allow-crypto=no --hide-browser --schedule-reset=1 --cache-del=200 --create-swap=10G & \
    \
    # Удерживаем контейнер в рабочем состоянии \
    tail -f /dev/null \
"
