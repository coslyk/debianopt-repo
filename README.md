# Debian 中文用户软件源
## Debian 中文社区软件源使用说明
Debian 中文社区提供了一系列软件，可作为对 Debian 官方仓库的一个补充， 其目的之一是改进 Debian 中文用户在 Debian 系统上的使用体验。

软件源支持`Debian 10`版本。

软件源通过自动化脚本自动检测软件版本更新，并自动构建安装包，因此能保证软件源中的软件总是最新的。

## 启用社区源的命令
```
echo "deb https://dl.bintray.com/coslyk/debianzh buster main" | sudo tee -a /etc/apt/sources.list
curl -o bintray-public.key.asc https://bintray.com/user/downloadSubjectPublicKey?username=bintray
sudo apt-key add bintray-public.key.asc
```

## 软件包列表
您可以在 [recipes](https://github.com/coslyk/debianzh-repo/tree/master/recipes) 中找到详细的软件包列表。

## For 打包者：维护指南
软件源通过自动化脚本自动维护，您只需编写`.yml`配置文件即可。具体请参见[Wiki](https://github.com/coslyk/debianzh-repo/wiki).
