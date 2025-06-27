###############################################################################
# Bitcoin-Knots GUI container (browser-based, no desktop required)
# Access: http://<host-ip>:6080/vnc.html
###############################################################################

FROM debian:bullseye-slim

###############################################################################
# 1) Minimal run-time deps
###############################################################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl ca-certificates git python3 procps \   
    x11vnc xvfb fluxbox xfonts-base \
    libqt5gui5 libqt5widgets5 libqt5core5a \
    libxcb-shape0 libxcb-xfixes0 libxcb-shm0 libxcb-render0 \
    libxcb-render-util0 libxcb-randr0 libxcb-image0 libxcb-keysyms1 \
    libxcb-icccm4 libxcb-xinerama0 libxcb-xinput0 libx11-xcb1 \
    libxcb-xkb1 libxkbcommon-x11-0 \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

###############################################################################
# 2) Install noVNC (browser VNC client)
###############################################################################
RUN git clone --depth 1 https://github.com/novnc/noVNC /opt/novnc     && \
    git clone --depth 1 https://github.com/novnc/websockify \
        /opt/novnc/utils/websockify

###############################################################################
# 3) Install Bitcoin Knots binaries
###############################################################################
ARG BKVER=28.1.knots20250305
RUN wget -q https://bitcoinknots.org/files/28.x/${BKVER}/\
bitcoin-${BKVER}-x86_64-linux-gnu.tar.gz && \
    tar -xf bitcoin-${BKVER}-x86_64-linux-gnu.tar.gz && \
    mv  bitcoin-${BKVER}/bin/* /usr/local/bin/ && \
    rm -rf bitcoin-${BKVER}*

###############################################################################
# 4) Add boot script
###############################################################################
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

###############################################################################
# 5) Container meta. Port 6080 = WebUI
############################################################################### 
VOLUME ["/bitcoin"]
EXPOSE 6080 5900 8332 8333
ENTRYPOINT ["/usr/local/bin/start.sh"]
