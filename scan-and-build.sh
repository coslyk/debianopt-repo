#!/bin/sh

EXIT_CODE=0

ls recipes | while read SUBDIR; do
    ./build-deb.sh recipes/$SUBDIR
    if [ $? != 0 ]; then
        EXIT_CODE=1
    fi
done

exit $EXIT_CODE