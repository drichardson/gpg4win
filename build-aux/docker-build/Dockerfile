# Setup a debian image that is ready to build gpg4win.
FROM debian:latest

# Combine apt-get statements per "Best practices for writing Dockerfile"
# instructions:
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run
# 1. Update apt packages
# 2. Install git, which is required even though not listed in required packages
#    in README, and the list of required packages copied directly from the top level
#    README.
RUN apt-get -y update && \
    apt-get -y install git \
    build-essential autoconf automake mingw-w64 mingw-w64-i686-dev \
    mingw-w64-x86-64-dev nsis stow unzip icoutils texlive \
    libglib2.0-dev gettext docbook-utils ghostscript \
    texinfo libgdk-pixbuf2.0-dev texlive-latex-extra libqt4-dev-bin \
    wget mingw-w64 texlive-lang-german cmake libgtk2.0-bin libxml2-utils \
    gperf libgettextpo-dev automake-1.15 libkf5config-dev libkf5config-dev-bin \
    libkf5coreaddons-dev gpgrt-tools imagemagick

# gpg4win-packages is a cache of /gpg4win/packages. This exsits only to make
# the build reliable. Without this cache, the build will fail if any endpoint
# listed in /gpg4win/packages/packages.current fails. container-build.sh will
# copy these files into place later.
COPY /build-aux/docker-build/gpg4win-packages /gpg4win-packages

# Debian's default image magick policy disables ghostscript, so overwrite it
# with a more permissive policy.
COPY /build-aux/docker-build/ImageMagick-6-policy.xml /etc/ImageMagick-6/policy.xml

# Copy the script that will perform the build inside the container.
COPY /build-aux/docker-build/container-build.sh /

# Copy the repo. Whatever HEAD is pointing at will be used.
COPY .git /gpg4win/.git

ENTRYPOINT ["/container-build.sh"]
