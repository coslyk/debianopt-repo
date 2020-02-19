#!/bin/bash -e

# This script is executed within the container as root.  It assumes
# that source code with debian packaging files can be found at
# /source-ro and that resulting packages are written to /output after
# succesful build.  These directories are mounted as docker volumes to
# allow files to be exchanged between the host and the container.


# Make read-write copy of source code
mkdir -p /build
cp -a /source-ro /build/source
cd /build/source


# Cross build?
if [ -n "${CROSS_TRIPLE}" ]; then
    CROSS_ARGS="--host-arch armhf"

    # dpkg cannot resolve cross dependency for npm, workaround:
    if cat debian/control | grep npm > /dev/null; then
	    sed -i 's/,*\s*npm\s*//g' debian/control
	    sed -i 's/:,/:/g' debian/control
        apt-get install npm
    fi
fi

# Install build dependencies
apt-get update
printf "Installing dependencies "
mk-build-deps $CROSS_ARGS -ir -t "apt-get -o Debug::pkgProblemResolver=yes -y --no-install-recommends" | while read LINE; do
    printf "."
done
printf "\n"

# Build packages
dpkg-buildpackage -b -uc -us $CROSS_ARGS

# Copy packages to output dir with user's permissions
chown -R $USER:$GROUP /build
cp -a /build/*.deb /output/
ls -l /output
