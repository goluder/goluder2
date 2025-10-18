FROM 9hitste/app

RUN apt-get update && apt-get install -y netcat-openbsd

# Сначала проверяем что там было
RUN echo "=== Было до копирования ===" && \
    ls -la /etc/9hitsv3-linux64/

# Удаляем старую папку и копируем новую
RUN rm -rf /etc/9hitsv3-linux64/config
COPY config /etc/9hitsv3-linux64/config

# Проверяем что получилось
RUN echo "=== Стало после копирования ===" && \
    ls -la /etc/9hitsv3-linux64/ && \
    echo "=== Содержимое config ===" && \
    ls -la /etc/9hitsv3-linux64/config/

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
