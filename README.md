# DebianOpt Repository

Package build status: [![Build Status](https://travis-ci.org/coslyk/debianopt-repo.svg?branch=main)](https://travis-ci.org/coslyk/debianopt-repo)

## Description

DebianOpt is an additional repository for Debian users. It provides packages of many interesting open-source softwares. It aims to make it easier to install softwares in Debian as well as providing a way for developers to distribute their awesome projects.

This repository focuses on the latest stable Debian version. Currently `Debian 11 (bullseye)` `Debian 10 (Buster)` is supported.

It uses scripts to check updates and build packages automatically, so we can ensure that all packages here are up-to-date!

## Add this repo

Debian 11: (hosted on Github Page)

```shell
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/coslyk/debianopt-repo/main/add-repo.sh)"
```

Debian 10: (hosted on Bintray and will be shut down in May 31)

```shell
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/coslyk/debianopt-repo/master/add-repo.sh)"
```

## Package list

You can obtain a list of packages from [package list](https://github.com/coslyk/debianopt-repo/wiki/Package-list) as well as [recipes](https://github.com/coslyk/debianopt-repo/tree/main/recipes).

## FAQ

#### Is it safe to use this repository?

It is safe to your Debian system. We use strict [packaging rules](https://github.com/coslyk/debianopt-repo/wiki/Packaging-rules) to ensure that the packages don't break the dependencies in the Debian's official repository, so installing packages from here won't affect softwares you've installed on your system.

However, since packages here are built automatically and not tested by human, the functionality of programs is not guaranteed. If you meet errors when launching the program, please submit an issue.

## For Developer: How to publish

Packages are maintained automatically using scripts. You only need to write a YAML config file. Please see [Wiki](https://github.com/coslyk/debianopt-repo/wiki) for details.
