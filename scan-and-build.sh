#!/bin/sh

EXIT_CODE=0

ls recipes | while read SUBDIR; do
    ./build-deb.sh recipes/$SUBDIR || EXIT_CODE=1
done

exit $EXIT_CODE