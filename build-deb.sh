#!/usr/bin/env bash


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

guess_package_url_github() {
    curl -s "https://api.github.com/repos/$1/releases/latest" | grep "browser_download_url" | grep "amd64.deb\"" | sed 's/.*\"\(.*amd64\.deb\)\".*/\1/g'
}

# Download infos from Github
if [ "$_source_host" = "github" ]; then
    TAG_NAME=$(get_latest_version_github "$_source_repo")
    LATEST_VERSION="${TAG_NAME#v}"
    if [ "$_source_method" = "build" ]; then
        if [ -n "${_source_source_url}" ]; then
            SOURCE_URL=`echo "${_source_source_url}" | sed "s|##VERSION|$LATEST_VERSION|g"`
        else
            SOURCE_URL="https://github.com/$_source_repo/archive/$TAG_NAME.tar.gz"
        fi
    else
        if [ -n "${_source_package_url}" ]; then
            PACKAGE_URL=`echo "${_source_package_url}" | sed "s|##VERSION|$LATEST_VERSION|g"`
        else
            PACKAGE_URL=$(guess_package_url_github "$_source_repo")
        fi
    fi

# Download infos from others
elif [ "$_source_host" = "other" ]; then
    LATEST_VERSION=`bash -c "${_source_get_version}"`
    if [ "$_source_method" = "build" ]; then
        if [ -n "${_source_get_source_url}" ]; then
            SOURCE_URL=`bash -c "${_source_get_source_url}"`
        else
            SOURCE_URL=`echo "${_source_source_url}" | sed "s|##VERSION|$LATEST_VERSION|g"`
        fi
    else
        if [ -n "${_source_get_package_url}" ]; then
            PACKAGE_URL=`bash -c "${_source_get_package_url}"`
        else
            PACKAGE_URL=`echo "${_source_package_url}" | sed "s|##VERSION|$LATEST_VERSION|g"`
        fi
    fi
else
    echo "Error: unsupported host: $_source_host" > /dev/stderr
    exit 1
fi


## Step 4: Check if the package of latest version exists
REMOTE_URL="https://dl.bintray.com/coslyk/debianzh/pool/main/${_name:0:1}/${_name}/${_name}_${LATEST_VERSION}-1~${DEBIAN_RELEASE}_amd64.deb"
if curl --output /dev/null --silent --head --fail "$REMOTE_URL"; then
    echo -e "\e[32m *** No update for $_name, skip. *** \e[0m"
    exit 0
else
    echo -e "\e[32m *** Detected update for $_name: $LATEST_VERSION *** \e[0m"
fi


## Step 5: Download source code or package
if [ "$_source_method" = "build" ]; then
    echo "Downloading source code from $SOURCE_URL"
    curl -L -o source.tar.gz "$SOURCE_URL" || exit 1
    tar xzf source.tar.gz
else
    echo "Downloading $PACKAGE_URL"
    curl -L -o package.deb "$PACKAGE_URL" || exit 1
fi


## Step 6: Build package if needed
if [ "$_source_method" = "build" ]; then

    SOURCE_DIR=`ls -d */ | sed 's/debian-template\///g' | sed 's/\///g'`

    # Copy debian folder
    cp -rf debian-template $SOURCE_DIR/debian
    find $SOURCE_DIR/debian -type f -exec sed -i -e "s|##VERSION|$LATEST_VERSION|g" {} \;
    find $SOURCE_DIR/debian -type f -exec sed -i -e "s|##RELEASE|$DEBIAN_RELEASE|g" {} \;
    
    # Build package
    echo "Building..."
    $HERE/travis/build -i docker-deb-builder:$DEBIAN_RELEASE -o . $SOURCE_DIR
    rm -f *-dbgsym_*.deb
    printf "Built: "
    ls *.deb || exit 1

elif [ -d "debian-template" ]; then
    # Repack deb
    dpkg-deb -x package.deb temp
    dpkg-deb -e package.deb temp/debian
    cp -rf debian-template temp/debian
    dpkg-deb -b temp repack.deb
    rm -f package.deb
fi

## Step 7: Upload
PACKAGE_INFO="{
  \"name\": \"${_name}\",
  \"licenses\": [\"MIT\"],
  \"vcs_url\": \"https://github.com/coslyk/debianzh-repo.git\",
  \"public_download_numbers\": false
}"

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
    echo "Uploading ..."

    # Create package folder on server
    curl -X POST -H "Content-type: application/json" -d "$PACKAGE_INFO" -ucoslyk:$BINTRAY_APIKEY "https://api.bintray.com/packages/coslyk/debianzh"
    echo ""

    # Upload files
    curl -X PUT -T *.deb -ucoslyk:$BINTRAY_APIKEY "https://api.bintray.com/content/coslyk/debianzh/${_name}/${LATEST_VERSION}/pool/main/${_name:0:1}/${_name}/${_name}_${LATEST_VERSION}-1~${DEBIAN_RELEASE}_amd64.deb;deb_distribution=${DEBIAN_RELEASE};deb_component=main;deb_architecture=amd64;publish=1"
fi

printf "\n\n"
