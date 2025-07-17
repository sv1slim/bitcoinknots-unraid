#!/bin/bash
set -e
export DISPLAY=:0 QT_QPA_PLATFORM=xcb

rm -f /tmp/.X0-lock             # ensure clean start
Xvfb :0 -screen 0 1280x800x16 & # virtual display
fluxbox &                       # tiny window manager

bitcoin-qt -datadir=/root/.bitcoin -conf=/root/.bitcoin/bitcoin.conf &  # GUI

x11vnc  -display :0 -forever -nopw -shared -rfbport 5900 &  # raw VNC
/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &  # browser VNC

tail -f /dev/null              # keep container alive
