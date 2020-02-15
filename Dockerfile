FROM arm32v7/alpine:latest

LABEL maintainer="ueni, ueniueni"

COPY qemu-arm-static /usr/bin

# Install dependencies to add Tor's repository.
RUN apk update && apk upgrade && \
    apk add tor && \
    rm /var/cache/apk/* && \
    addgroup -g 20000 -S tord && adduser -u 20000 -G tord -S tord && \
    chown -Rv tord:tord /home/tord/

COPY torrc.bridge /etc/tor/torrc.bridge
COPY torrc.middle /etc/tor/torrc.middle
COPY torrc.exit /etc/tor/torrc.exit

COPY config.sh /etc/tor/config.sh
RUN chmod +x /etc/tor/config.sh

EXPOSE 9050/tcp
VOLUME /etc/tor /home/tord/.tor

CMD [ "/etc/tor/config.sh"]
