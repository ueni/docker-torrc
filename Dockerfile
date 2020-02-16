FROM arm32v7/debian:stable-slim

LABEL maintainer="ueni, ueniueni"

COPY qemu-arm-static /usr/bin

# Install dependencies to add Tor's repository.
RUN apt-get update && apt-get install -y \
    libcap2-bin \
    curl \
    gpg \
    gpg-agent \
    ca-certificates \
    --no-install-recommends

# See: <https://2019.www.torproject.org/docs/debian.html.en>
RUN curl --verbose -k https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

RUN printf "deb https://deb.torproject.org/torproject.org stable main\n" >> /etc/apt/sources.list.d/tor

# Install remaining dependencies.
RUN apt-get update && apt-get install -y \
    tor \
    tor-geoipdb \
    obfs4proxy \
    --no-install-recommends

# Allow obfs4proxy to bind to ports < 1024.
RUN setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy
    
COPY torrc.bridge /data/torrc.bridge
COPY torrc.middle /data/torrc.middle
COPY torrc.exit /data/torrc.exit
COPY torrc.vpn /data/torrc.vpn

COPY config.sh /data/config.sh
RUN chmod +x /data/config.sh

EXPOSE 9050/tcp
VOLUME /etc/tor /var/log/tor /home/debian-tor/.tor

USER debian-tor

CMD [ "/data/config.sh"]
