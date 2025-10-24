# ИСХОДНЫЙ ОБРАЗ

FROM 9hitste/app:latest


# 1. Установка общих утилит (только тех, что не ставятся при первом запуске /nh.sh)

RUN apt-get update && \

    apt-get install -y wget tar netcat-openbsd bash && \

    rm -rf /var/lib/apt/lists/*


# 2. Установка порта

ENV PORT 8000

EXPOSE 8000


# 3. КОМАНДА ЗАПУСКА (CMD)

# Все критические шаги, включая первый запуск /nh.sh и конфигурирование,

# должны быть выполнены здесь, в одном скрипте.

CMD bash -c " \

    # --- ШАГ А: ПЕРВЫЙ ЗАПУСК /nh.sh (для создания структуры директорий) ---

    # Запускаем /nh.sh в фоне. Мы предполагаем, что он создает /etc/9hitsv3-linux64/config/

    /nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot --allow-crypto=no --hide-browser --schedule-reset=1 --cache-del=200 --create-swap=10G & \

    

    # Даем программе 50 секунд, чтобы полностью установиться и создать директории

    sleep 50; \

    

    # --- ШАГ Б: КОПИРОВАНИЕ КОНФИГОВ (После установки программы) ---

    echo 'Начинаю копирование конфигурации...' && \

    # Загружаем, распаковываем и копируем конфиги

    wget -q -O /tmp/main.tar.gz https://github.com/atrei73/9hits-project/archive/main.tar.gz && \

    tar -xzf /tmp/main.tar.gz -C /tmp && \

    cp -r /tmp/9hits-project-main/config/* /etc/9hitsv3-linux64/config/ && \

    rm -rf /tmp/main.tar.gz /tmp/9hits-project-main && \

    echo 'Копирование конфигурации завершено.'; \

    

    # --- ШАГ В: ЗАПУСК HEALTH CHECK ---

    # Запускаем Health Check в фоне для Sliplane

    while true; do echo -e 'HTTP/1.1 200 OK\r\n\r\nOK' | /usr/bin/nc -l -p ${PORT} -q 0 -w 1; done & \

    \

    # --- ШАГ Г: УДЕРЖАНИЕ КОНТЕЙНЕРА ---

    tail -f /dev/null \

"
