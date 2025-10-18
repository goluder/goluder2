FROM 9hitste/app

RUN apt-get update && apt-get install -y netcat-openbsd

# Копируем СОДЕРЖИМОЕ папки config, а не саму папку
COPY config/* /etc/9hitsv3-linux64/config/

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
