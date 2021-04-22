#!/bin/sh

echo "Removing outdated packages..."

get_outdated_packages() {
    cloudsmith list packages debianopt/debianopt -F json -l 1000 | \
        python3 -c "import sys, json; print('\n'.join([ i['slug_perm'] for i in json.load(sys.stdin)['data'] if len(i['tags']) == 0 ]))"
}

OUTDATED_PACKAGES=`get_outdated_packages`

for PKG in ${OUTDATED_PACKAGES}; do
    cloudsmith delete -y debianopt/debianopt/$PKG
done