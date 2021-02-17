#!/bin/bash
# This script is run from inside the Docker container.

set -e

# Only .git was copied to the container. Checkout a working copy.
cd /gpg4win
git checkout .

# Move packages from the cache into place.
mv /gpg4win-packages/packages/* /gpg4win/packages/

# Follow build instructions from top level README.
cd /gpg4win/packages
sh download.sh

cd /gpg4win
./autogen.sh
./autogen.sh --build-w32
make
