#!/bin/sh

# Get release codename
RELEASE=`lsb_release -sc`
if [ "$RELEASE" != "buster" ]; then
    echo "Sorry! Currently only Debian 10 buster is supported."
    exit 1
fi


# Choose mirror
cat << 'EOF'
Please choose a mirror:
  0: Bintray (Global)
  1: USTC (China)
EOF
read MIRROR_NUMBER

case "$MIRROR_NUMBER" in
    0)  MIRROR="https://dl.bintray.com/debianopt/debianopt"
    ;;
    1)  MIRROR="https://bintray.proxy.ustclug.org/debianopt/debianopt"
    ;;
    *)  echo "Please select a valid number."
        exit 1
    ;;
esac


# Write source list
echo "deb $MIRROR $RELEASE main" > /etc/apt/sources.list.d/debianopt.list


# Add key
which curl > /dev/null || apt-get install -y curl
curl -L https://bintray.com/user/downloadSubjectPublicKey?username=bintray | apt-key add -

# Update
apt-get update

# Finish
echo ""
echo "Congratulations! DebianOpt is set up successfully."
