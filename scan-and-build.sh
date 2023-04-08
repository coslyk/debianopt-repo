#!/bin/sh

# Clone repository for binary packages
SSHPATH="$HOME/.ssh"
rm -rf "$SSHPATH"
mkdir -p "$SSHPATH"
echo "${{ secrets.ACCESS_KEY }}" > "$SSHPATH/id_rsa"
chmod 600 "$SSHPATH/id_rsa"
sudo sh -c "echo StrictHostKeyChecking no >>/etc/ssh/ssh_config"
git clone --depth 1 "git@github.com:coslyk/debianopt.git"

# Scan and build
export UPLOAD_AFTER_BUILD=true
ls recipes | while read SUBDIR; do
    ./build-deb.sh recipes/$SUBDIR || echo "$SUBDIR" >> failure.txt
done

# Upload packages
git config --global user.name 'YK Liu'
git config --global user.email 'cos.lyk@gmail.com'
cd debianopt
git add --all
git commit -a -m "Automatic update: $(date "+%D %T")"
git push
cd ..