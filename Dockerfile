# ИСХОДНЫЙ ОБРАЗ
FROM 9hitste/app:latest

# 1. Установка общих утилит (netcat, wget, tar, bash)
# Используем 'netcat-openbsd' (наиболее вероятно для Debian/Ubuntu)
RUN apt-get update && \
    apt-get install -y wget tar netcat-openbsd bash && \
    rm -rf /var/lib/apt/lists/*

# 2. ПЕРВЫЙ ЗАПУСК /nh.sh (во время сборки)
# Мы должны запустить /nh.sh, чтобы он создал необходимые директории.
# Используем просто команду для установки, без фонового режима.
RUN /nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot --allow-crypto=no --hide-browser --schedule-reset=1 --cache-del=200 --create-swap=10G || true
# Добавляем '|| true' на случай, если скрипт пытается завершиться.

# 3. Установка порта (необязательно, но полезно)
ENV PORT 8000
EXPOSE 8000

# КОМАНДА CMD в Dockerfile теперь пуста или является простой заглушкой.
# CMD ["tail", "-f", "/dev/null"]
