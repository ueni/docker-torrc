# docker-torrc

This repository contains the docker files for a Tor relay.

## Releasing a new image

First, build the image:

    make build

Next, release a new version by adding a tag:

    make tag VERSION=X.Y

Finally, release the image:

    make release VERSION=X.Y

Once we released a new image version, we tag the respective git commit:

    git tag -a -s "vVERSION" -m "Docker image version VERSION."
    git push --tags origin master
