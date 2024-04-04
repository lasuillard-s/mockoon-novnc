FROM theasp/novnc:latest

RUN apt-get update && apt-get install -y \
    fonts-noto \
    nginx \
    wget \
    # Mockoon
    libasound2 \
    libatspi2.0-0 \
    libgbm-dev \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libsecret-1-0 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    && apt-get clean

ARG MOCKOON_VERSION="8.0.0"
RUN wget --output-document /tmp/mockoon.deb "https://github.com/mockoon/mockoon/releases/download/v${MOCKOON_VERSION}/mockoon-${MOCKOON_VERSION}.$(dpkg --print-architecture).deb" \
    && dpkg -i /tmp/mockoon.deb \
    && rm /tmp/mockoon.deb

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./mockoon/storage/* /root/.config/mockoon/storage/
COPY ./supervisord/conf.d/* /app/conf.d/

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
