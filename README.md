# DebianOpt Repository
## Description
DebianOpt Repository provides a wide range of open-source softwares. It aims to improve the user experience of Debian Linux as well as providing a way for developers to distribute their awesome projects.

This repository currently supports `Debian 10 (Buster)`.

All packages are updated and built automatically using our automation scripts, so we can ensure that all packages here are up-to-date!

## How to use
```
echo "deb https://dl.bintray.com/debianopt/debianopt buster main" | sudo tee -a /etc/apt/sources.list
curl -o bintray-public.key.asc https://bintray.com/user/downloadSubjectPublicKey?username=bintray
sudo apt-key add bintray-public.key.asc
```

## Package list
You can obtain a list of packages from [package list](https://github.com/coslyk/debianopt-repo/wiki/Package-lists) as well as [recipes](https://github.com/coslyk/debianopt-repo/tree/master/recipes).

## For Developer: How to publish
Packages are maintained automatically using scripts. You only need to write a YAML config file. Please see [Wiki](https://github.com/coslyk/debianopt-repo/wiki) for details.
