#!/bin/sh


# Create file lists on the server
cloudsmith list packages debianopt/debianopt -F json -l 1000 | \
    python3 -c "import sys, json; print('\n'.join([i['filename'] for i in json.load(sys.stdin)['data']]))" > filelist.txt

# Scan and build
export UPLOAD_AFTER_BUILD=true
ls recipes | while read SUBDIR; do
    ./build-deb.sh recipes/$SUBDIR || echo "$SUBDIR" >> failure.txt
done