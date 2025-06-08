FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    git \
    mariadb-client \
    curl \
    cron \
    gnupg \
    redis-server && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn@1.22.19 && \
    useradd -ms /bin/bash frappe

COPY bootstrap.sh /bootstrap.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /bootstrap.sh /entrypoint.sh

USER frappe
WORKDIR /home/frappe

RUN pip install --user frappe-bench && \
    ~/.local/bin/bench init frappe-bench --frappe-branch version-15 --skip-assets

ENTRYPOINT ["/entrypoint.sh"]
