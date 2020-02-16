FROM arm32v7/alpine:latest

LABEL maintainer="ueni, ueniueni"

COPY qemu-arm-static /usr/bin

# Install dependencies to add Tor's repository.
RUN apk update && apk upgrade && \
    apk add go git ca-certificates tor libcap && \
    rm /var/cache/apk/* && \
    addgroup -g 20000 -S tord && adduser -u 20000 -G tord -S tord && \
    chown -Rv tord:tord /home/tord/ && \
    mkdir -p /go/src /go/bin && \
    chmod -R 644 /go 

ENV GOPATH /go
ENV PATH /go/bin:$PATH
WORKDIR /go    

# Install obfs4proxy 
# Give obfs4proxy the capability to bind port 80. This line isn't necessary if
# you use a high (unprivileged) port.
RUN go get git.torproject.org/pluggable-transports/obfs4.git/obfs4proxy && \
    mv /go/bin/obfs4proxy /usr/local/bin/obfs4proxy && \
    setcap 'cap_net_bind_service=+ep' /usr/local/bin/obfs4proxy

COPY torrc.bridge /data/torrc.bridge
COPY torrc.middle /data/torrc.middle
COPY torrc.exit /data/torrc.exit
COPY torrc.vpn /data/torrc.vpn

COPY config.sh /data/config.sh
RUN chmod +x /data/config.sh

EXPOSE 9050/tcp
VOLUME /etc/tor /home/tord/.tor

CMD [ "/data/config.sh"]
