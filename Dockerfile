FROM mcr.microsoft.com/devcontainers/base:ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y \
    lxde-core lxde-common lxsession openbox \
    x11vnc xvfb novnc websockify \
    supervisor net-tools sudo firefox locales \
 && locale-gen en_US.UTF-8 \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN printf '#!/usr/bin/env bash\n\
export DISPLAY=:0\n\
Xvfb :0 -screen 0 1280x720x24 &\n\
sleep 2\n\
openbox &\n\
lxsession -s LXDE -e LXDE &\n\
x11vnc -display :0 -rfbport 5901 -forever -shared -nopw &\n\
websockify --web=/usr/share/novnc/ 6080 localhost:5901\n\
' > /usr/local/bin/start-desktop.sh && chmod +x /usr/local/bin/start-desktop.sh
