# AltiWx-Docker

This is a dockerized version of [AltiWx](https://github.com/altillimity/AltiWx), a software-package to decode NOAA and Meteor weathersatellites.
The container is based on Debian:bullseye-slim.

## What is AltiWx

This is a software that was made after experimenting around with several automated satellite station solutions, mostly aimed at the **NOAA APT and METEOR LRPT transmissions on VHF**. Originally software was used, that wrapped around rtl_fm and other tools such as sox, predict, some APT decoder, etc to automatically record and decode passes. It worked great but bothering was the fact, that this same RTL-SDR has 2.4Mhz of usable bandwidth... So in theory the whole VHF weather band can fit right? And that's how the idea started.

AltiWx is an automated satellite station recording software built from the ground up for that purpose, with integrated DSP, pass prediction and processing mechanism. Recording is done by monitoring a whole portion of the spectrum, and by some digital signal processing, isolate each signal from this whole sampled spectrum to allow recording as many satellites (or downlinks) in parrallel as you want as long as long as they fit in the bandwidth of your SDR!  
Obviously, this brought up a few issues such as how to properly handle passes of satellites that do not fit in the bandwidth... In the end it will prioritize better passes (or satellite priorities set in the configuration file) per-band as doable.

In fact, AltiWx will only ever tune the SDR to some predefined frequency bands in the configuration, as an example let's take 137.5Mhz and 145Mhz at 2.4Mhz bandwidth.
With this SDR configuration, you could have NOAA 19, which has both APT on 137.1Mhz and DSB on 137.77Mhz.

Important: **If transits of satellites happen at the same time, AltiWx will be able to process all of them and not only one**

## Installation

```shell
cd ~
git clone https://github.com/ploeffler/AltiWx-Docker
cd AltiWx-Docker
wget https://raw.githubusercontent.com/altillimity/AltiWx/master/config.yml
```

Edit the config.yml file to meet your requirements.

### NOAA Satellites

```
  - norad: 33591 # NOAA 19
    min_elevation: 10
    priority: 1
    downlinks:
      - name: APT
        frequency: 137100000
        bandwidth: 42000
        doppler: false
        post_processing_script: apt-noaa.py
        output_extension: wav
        type: FM
        parameters:
          audio_samplerate: 48000
      - name: DSB
        frequency: 137770000
        bandwidth: 48000
        doppler: false
        post_processing_script: none
        output_extension: raw
        type: IQ
```

The **post_processing_script** can either be:

- apt-noaa.py
- apt-noaa-noaaapt.py
- apt-noaa-wx2img.py
  
Nevertheless wx2img is not (yet) part of this docker container.

The DSB part can be prost-processed with dsb-noaa.py

### METEOR Satellites

```- norad: 40069 # METEOR-M 2
    min_elevation: 10
    priority: 1
    downlinks:
      - name: LRPT
        frequency: 137100000
        bandwidth: 140000
        doppler: false
        post_processing_script: lrpt-meteorm2.py
        output_extension: soft
        type: QPSK
        parameters:
          agc_rate: 0.1
          symbolrate: 72000
          rrc_alpha: 0.6
          rrc_taps: 31
          costas_bw: 0.005
```

The **post_processing_script** can either be:

- lrpt-meteorm2.py
- lrpt-meteorm2-extended.py
- lrpt-meteormn2-satdump.py

### ISS 

```- norad: 25544 # ISS
    min_elevation: 20
    priority: 1
    downlinks:
      - name: SSTV
        frequency: 145800000
        bandwidth: 14000
        doppler: true
        post_processing_script: none
        output_extension: wav
        type: FM
        parameters:
          audio_samplerate: 48000
      - name: APRS
        frequency: 145825000
        bandwidth: 12000
        doppler: true
        post_processing_script: none
        output_extension: wav
        type: FM
        parameters:
          audio_samplerate: 48000
```

(More details on the post-processing-scripts you can find in [the sources of AltiWx](https://github.com/altillimity/AltiWx/tree/master/scripts))

After that having configured we are ready to go. Depending on your platform this will take several minutes:

```shell
docker compose -t altiwx .
docker run --privileged -v /dev/bus/usb:/dev/bus/usb -v $(pwd)/config.yml:/opt/AltiWx/config.yml --name altiwx --network host -d --restart unless-stopped -v $(pwd)/data:/opt/AltiWx/data -dt altiwx '/opt/AltiWx/AltiWx'
```

(depending on your system you may require to run "sudo docker ..." )