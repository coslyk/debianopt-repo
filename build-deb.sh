#!/usr/bin/env bash

## Build environments

## Step 1: Enter directory
HERE="$(dirname "$(readlink -f "${0}")")"
cd $1


## Step 2: Read the recipe YAML file
parse_yaml() {
    local prefix=$2
    local s
    local w
    local fs
    s='[[:blank:]]*'
    w='[a-zA-Z0-9_]*'
    fs="$(echo @|tr @ '\034')"
    sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" "$1" |
    awk -F"$fs" '{
    indent = length($1)/2;
    vname[indent] = $2;
    for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            printf("%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, $3);
        }
    }' | sed 's/_=/+=/g'
}
eval $(parse_yaml recipe.yml "_")


## Step 3: Get latest version and source url
get_latest_version_github() {
    export PYTHONIOENCODING=utf8
    curl -s "https://api.github.com/repos/$1/releases/latest" | \
    python -c "import sys, json; sys.stdout.write(json.load(sys.stdin)['tag_name'])"
}

if [ "$_source_host" = "github" ]; then
    LATEST_VERSION=$(get_latest_version_github "$_source_repo")
    SOURCE_URL="https://github.com/$_source_repo/archive/$LATEST_VERSION.tar.gz"
    LATEST_VERSION="${LATEST_VERSION#v}"
    SOURCE_DIR="${_name}-${LATEST_VERSION}"
else
    echo "Error: unsupported host: $_source_host" > /dev/stderr
    exit 1
fi


## Step 4: Check if the package of latest version exists
PACKAGE_URL="https://dl.bintray.com/coslyk/debianzh/pool/main/${_name:0:1}/${_name}/${_name}_${LATEST_VERSION}-1~${DEBIAN_RELEASE}_${DEBIAN_ARCH}.deb"
if curl --output /dev/null --silent --head --fail "$PACKAGE_URL"; then
    exit 0
else
    echo -e "\e[32m *** Detect update for $_name: $LATEST_VERSION *** \e[0m"
fi


## Step 5: Download source code
echo "Downloading source code from $SOURCE_URL"
curl -L -o source.tar.gz "$SOURCE_URL"
tar xzf source.tar.gz


## Step 6: Create debian directory
if [ "$_source_method" = "build" ]; then
    [ -d $SOURCE_DIR/debian ] && rm -rf $SOURCE_DIR/debian
    cp -r debian-template $SOURCE_DIR/debian
    find $SOURCE_DIR/debian -type f -exec sed -i -e "s|##VERSION|$LATEST_VERSION|g" {} \;
    find $SOURCE_DIR/debian -type f -exec sed -i -e "s|##RELEASE|$DEBIAN_RELEASE|g" {} \;
fi


## Step 7: Build package
printf "Building "
$HERE/travis/build -i docker-deb-builder:buster -o . $SOURCE_DIR | while read LINE; do
    printf "."
done
printf "\n"
rm -f *-dbgsym_*.deb
printf "Built: "
ls *.deb

# Step 9: Upload
echo "Uploading ..."
if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
    curl -X PUT -T *.deb -ucoslyk:$BINTRAY_APIKEY "https://api.bintray.com/content/coslyk/debianzh/${_name}/${LATEST_VERSION}/pool/main/${_name:0:1}/${_name}/${_name}_${LATEST_VERSION}-1~${DEBIAN_RELEASE}_${DEBIAN_ARCH}.deb;deb_distribution=${DEBIAN_RELEASE};deb_component=main;deb_architecture=${DEBIAN_ARCH};publish=1"
fi
printf "\n\n"