#!/bin/sh

# Clone repository for binary packages
git clone --depth 1 "https://${GITHUB_TOKEN}@github.com/coslyk/debianopt.git"

# Scan and build
export UPLOAD_AFTER_BUILD=true
ls recipes | while read SUBDIR; do
    ./build-deb.sh recipes/$SUBDIR || echo "$SUBDIR" >> failure.txt
done

# Upload packages
cd debianopt
git add --all
git commit -a -m "Automatic update: $(date "+%D %T")"
git push
cd ..