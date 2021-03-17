#!/bin/sh


if [ -z "$TRAVIS_PULL_REQUEST_BRANCH" ]; then    # Normal commit or cron job

    export BUILD_MODE=deploy

    # Clone repository for binary packages
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
    git clone --depth 1 "https://${GITHUB_TOKEN}@github.com/coslyk/debianopt.git"

    # Timing
    START=`date +%s`

    # Scan and build
    ls recipes | while read SUBDIR; do
        ./build-deb.sh recipes/$SUBDIR || echo "$SUBDIR" >> failure.txt
        
        # Travis CI allows maximum 1h
        END=`date +%s`
        RUNTIME=$((END-START))
        if [ $RUNTIME -gt 2400  ]; then
            break
        fi
    done

    # Upload packages
    cd debianopt
    git add --all
    git commit -a -m "Automatic update: $(date "+%D %T")"
    git push
    cd ..

else  # Pull request
    export BUILD_MODE=test
    ./build-deb.sh recipes/$TRAVIS_PULL_REQUEST_BRANCH || echo "$SUBDIR" >> failure.txt
fi