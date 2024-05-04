# AltiWx-Docker

This is a dockerized version of [AltiWx](https://github.com/altillimity/AltiWx), a software-package to decode NOAA and Meteor weathersatellites.

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
docker run -v $(pwd)/data:
