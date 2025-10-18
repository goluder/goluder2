FROM 9hitste/app

RUN apt-get update && apt-get install -y netcat-openbsd

# Создаем папку bot если ее нет
RUN mkdir -p /etc/9hitsv3-linux64/config/bot

# Копируем файлы настроек
COPY config/settings.json /etc/9hitsv3-linux64/config/
COPY config/bot/* /etc/9hitsv3-linux64/config/bot/

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
