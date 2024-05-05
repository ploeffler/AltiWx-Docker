# AltiWx-Docker

This is a dockerized version of [AltiWx](https://github.com/altillimity/AltiWx), a software-package to decode NOAA and Meteor weathersatellites.
The container is based on Debian:bullseye-slim.


## Installation

```shell
cd ~
git clone https://github.com/ploeffler/AltiWx-Docker
cd AltiWx-Docker
wget https://raw.githubusercontent.com/altillimity/AltiWx/master/config.yml
```

Edit the config.yml file to meet your requirements. 

```shell
docker compose -t altiwx .
docker run --privileged -v /dev/bus/usb:/dev/bus/usb -v $(pwd)/config.yml:/opt/AltiWx/config.yml --name altiwx --network host -d --restart unless-stopped -v $(pwd)/data:/opt/AltiWx/data -dt altiwx '/opt/AltiWx/AltiWx'
```
