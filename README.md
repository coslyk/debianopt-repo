# DebianOpt Repository

## Description

DebianOpt Repository provides a wide range of open-source softwares. It aims to improve the user experience of Debian Linux as well as providing a way for developers to distribute their awesome projects.

This repository focuses on the latest stable Debian version. Currently `Debian 10 (Buster)` is supported. Supported CPU architectures are: `amd64` `i386` `arm64` `armhf` `mips64el`.

It uses scripts to check updates and build packages automatically, so we can ensure that all packages here are up-to-date!

## How to use

```bash
sudo bash -c "echo 'deb https://dl.bintray.com/debianopt/debianopt buster main' >> /etc/apt/sources.list.d/debianopt.list"
curl -o bintray-public.key.asc https://bintray.com/user/downloadSubjectPublicKey?username=bintray
sudo apt-key add bintray-public.key.asc
```

Or see [Wiki](https://github.com/coslyk/debianopt-repo/wiki/Add-the-repo) for details.

## Mirrors and Proxies

Use mirrors or proxies to speed up the downloads. See [Mirrors and Proxies](https://github.com/coslyk/debianopt-repo/wiki/Mirrors-and-Proxies) for details.

## Package list

You can obtain a list of packages from [package list](https://github.com/coslyk/debianopt-repo/wiki/Package-list) as well as [recipes](https://github.com/coslyk/debianopt-repo/tree/master/recipes).

## FAQ

#### Is it safe to use this repository?

It is safe to your Debian system. We use strict [packaging rules](https://github.com/coslyk/debianopt-repo/wiki/Packaging-rules) to ensure that the packages don't break the dependencies in the Debian's official repository, so installing packages from here won't affect softwares you've installed on your system.

However, since packages here are built automatically and not tested by human, the functionality of programs is not guaranteed. If you meet errors when launching the program, please submit an issue.

## For Developer: How to publish

Packages are maintained automatically using scripts. You only need to write a YAML config file. Please see [Wiki](https://github.com/coslyk/debianopt-repo/wiki) for details.
