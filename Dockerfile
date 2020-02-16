FROM arm32v7/alpine:latest

LABEL maintainer="ueni, ueniueni"

COPY qemu-arm-static /usr/bin

# Install dependencies to add Tor's repository.
RUN apk update && apk upgrade && \
    apk add tor && \    
    apk add obfs4proxy && \
    rm /var/cache/apk/* && \
    addgroup -g 20000 -S tord && adduser -u 20000 -G tord -S tord && \
    chown -Rv tord:tord /home/tord/

COPY torrc.bridge /data/torrc.bridge
COPY torrc.middle /data/torrc.middle
COPY torrc.exit /data/torrc.exit
COPY torrc.vpn /data/torrc.vpn

COPY config.sh /data/config.sh
RUN chmod +x /data/config.sh

EXPOSE 9050/tcp
VOLUME /etc/tor /home/tord/.tor

CMD [ "/data/config.sh"]
