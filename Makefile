IMAGE=ueniueni/arm32v7-torrc

.PHONY: tag
tag:
	@[ "${VERSION}" ] || ( echo "Env var VERSION is not set."; exit 1 )
	docker tag $(IMAGE) $(IMAGE):$(VERSION)
	docker tag $(IMAGE) $(IMAGE):latest

.PHONY: release
release:
	@[ "${VERSION}" ] || ( echo "Env var VERSION is not set."; exit 1 )
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

.PHONY: build
build:
	docker build -t $(IMAGE) .

.PHONY: deploy
deploy:
	@[ "${PORT}" ] || ( echo "Env var OR_PORT is not set."; exit 1 )
	@docker run \
		--detach \
		--publish ${PORT}:9050\
		--restart unless-stopped \
		--volume torrc-datadir:/var/lib/tor \
		$(IMAGE):latest
	@echo "Make sure that the PORT ${PORT} are forwarded in your firewall."
