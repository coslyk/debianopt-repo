#!/bin/sh


if [ -z "$TRAVIS_PULL_REQUEST_BRANCH" ]; then    # Normal commit or cron job
    # Create file lists on the server
    cloudsmith list packages debianopt/debianopt -F pretty_json | \
        python3 -c "import sys, json; print('\n'.join([i['filename'] for i in json.load(sys.stdin)['data']]))" > filelist.txt

    # Scan and build
    EXIT_CODE=0
    ls recipes | while read SUBDIR; do
        ./build-deb.sh recipes/$SUBDIR || echo "$SUBDIR" >> failure.txt
    done

else  # Pull request
    ./build-deb.sh recipes/$TRAVIS_PULL_REQUEST_BRANCH || echo "$SUBDIR" >> failure.txt
fi