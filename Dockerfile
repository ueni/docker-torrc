FROM arm32v7/alpine:latest

LABEL maintainer="ueni, ueniueni"

COPY qemu-arm-static /usr/bin

# Install dependencies to add Tor's repository.
RUN apk update && apk upgrade && \
    apk add tor && \
    rm /var/cache/apk/* && \
    cp /etc/tor/torrc.sample /etc/tor/torrc

RUN echo "SocksPort 0.0.0.0:9050" > /etc/tor/torrc

VOLUME [ "/etc/tor" ]
EXPOSE 9050/tcp

USER tor
CMD [ "/usr/bin/tor -f /etc/tor/torrc"]
