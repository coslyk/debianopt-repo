#!/bin/sh

ls recipes | while read SUBDIR; do
    ./build-deb.sh recipes/$SUBDIR || exit 1
done