#!/bin/sh


if [ -z "$TRAVIS_PULL_REQUEST_BRANCH" ]; then    # Normal commit or cron job

    export BUILD_MODE=deploy

    # Clone repository for binary packages
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
    git clone --depth 1 "https://${GITHUB_TOKEN}@github.com/coslyk/debianopt.git"

    # Scan and build
    ls recipes | while read SUBDIR; do
        ./build-deb.sh recipes/$SUBDIR || echo "$SUBDIR" >> failure.txt
    done

else  # Pull request
    export BUILD_MODE=test
    ./build-deb.sh recipes/$TRAVIS_PULL_REQUEST_BRANCH || echo "$SUBDIR" >> failure.txt
fi