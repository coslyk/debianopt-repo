#!/bin/sh


if [ -z "$TRAVIS_PULL_REQUEST_BRANCH" ]; then    # Normal commit or cron job
    EXIT_CODE=0
    ls recipes | while read SUBDIR; do
        ./build-deb.sh recipes/$SUBDIR || echo "$SUBDIR" >> failure.txt
    done

else  # Pull request
    ./build-deb.sh recipes/$TRAVIS_PULL_REQUEST_BRANCH || echo "$SUBDIR" >> failure.txt
fi