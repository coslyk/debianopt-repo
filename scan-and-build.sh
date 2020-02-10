#!/bin/sh


if [ -z "$TRAVIS_PULL_REQUEST_BRANCH" ]; then    # Normal commit
    EXIT_CODE=0
    ls recipes | while read SUBDIR; do
        ./build-deb.sh recipes/$SUBDIR || EXIT_CODE=1
    done
    exit $EXIT_CODE

else  # Pull request
    ./build-deb.sh recipes/$TRAVIS_PULL_REQUEST_BRANCH
fi