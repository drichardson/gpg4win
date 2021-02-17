#!/bin/bash

set -e

IMAGE=gpg4win-builder-image

SCRIPTDIR=$(dirname "$0")
SCRIPTDIR=$(readlink -f "$SCRIPTDIR")
GPG4WINDIR=$(readlink -f "$SCRIPTDIR/../..")
OUTPUTDIR="$SCRIPTDIR/installers"

# Download and update the package cache this is used by the Dockerfile.
PACKAGECACHE="$SCRIPTDIR/gpg4win-packages"
if [[ ! -d "$PACKAGECACHE" ]]; then
	git clone https://github.com/drichardson/gpg4win-packages.git "$PACKAGECACHE"
fi
git -C "$PACKAGECACHE" pull --ff-only

# Build the image.
docker image build -f "$SCRIPTDIR/Dockerfile" -t $IMAGE "$GPG4WINDIR"

# Run the build.
CONTAINER=gpg4win-builder-$(head -c 32 /dev/urandom|shasum|cut -c1-8)
cleanup() {
	echo Removing up container $CONTAINER
	docker container rm -f $CONTAINER
}
trap cleanup EXIT

# Run build. Use tty to print output. If a terminal is connected, use
# interactive mode so control+C can stop it.
INTERACTIVE_IF_TTY=
if [[ -t 0 ]]; then
	INTERACTIVE_IF_TTY=--interactive
fi
docker container run --name $CONTAINER --tty $INTERACTIVE_IF_TTY $IMAGE

# Copy the executables to back to the host.
docker container cp $CONTAINER:/gpg4win/src/installers "$OUTPUTDIR"
