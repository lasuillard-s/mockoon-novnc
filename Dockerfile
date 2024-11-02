FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    fluxbox \
    fonts-noto \
    libasound2 \
    libatspi2.0-0 \
    libgbm-dev \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libsecret-1-0 \
    libxss1 \
    libxtst6 \
    nginx \
    novnc \
    supervisor \
    wget \
    x11vnc \
    xdg-utils \
    xvfb \
    && apt-get clean

ARG MOCKOON_VERSION="9.0.0"
RUN wget --output-document /tmp/mockoon.deb "https://github.com/mockoon/mockoon/releases/download/v${MOCKOON_VERSION}/mockoon-${MOCKOON_VERSION}.$(dpkg --print-architecture).deb" \
    && dpkg -i /tmp/mockoon.deb \
    && rm /tmp/mockoon.deb

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./mockoon/storage/* /root/.config/mockoon/storage/
COPY ./supervisord/conf.d/* /app/conf.d/
COPY ./supervisord/supervisord.conf /app/supervisord.conf

COPY ./docker-entrypoint.sh /

ENV DISPLAY=":0.0" \
    DISPLAY_WIDTH="1024" \
    DISPLAY_HEIGHT="768"

ENTRYPOINT ["/docker-entrypoint.sh"]
