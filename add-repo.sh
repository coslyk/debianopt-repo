#!/bin/sh

# Get release codename
RELEASE=`lsb_release -sc`
if [ "$RELEASE" != "bookworm" ]; then
    echo "Sorry! Currently only Debian 12 (bookworm) is supported."
    exit 1
fi


MIRROR="https://coslyk.github.io/debianopt"


# Write source list
echo "deb $MIRROR $RELEASE main" > /etc/apt/sources.list.d/debianopt.list


# Add key
which curl > /dev/null || apt-get install -y curl
curl -L $MIRROR/public.key -o /etc/apt/trusted.gpg.d/debianopt.asc

# Update
apt-get update

# Finish
echo ""
echo "Congratulations! DebianOpt is set up successfully."