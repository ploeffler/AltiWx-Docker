FROM debian:bullseye-slim
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install libspdlog-dev librtlsdr-dev libfmt-dev pybind11-dev python3-dev libliquid-dev cmake build-essential git python3-mako  libvolk2-bin \
                    libyaml-cpp-dev wget libfftw3-bin libnng1 libhackrf0 libairspy0 libairspyhf1 libglfw3  libjemalloc2 libopencv-dev python3-opencv gcc libsndfile-dev libpng-dev -y
RUN apt-get clean

WORKDIR /opt
RUN wget https://www.libvolk.org/releases/volk-2.5.2.tar.gz
RUN tar -xvzf volk-2.5.2.tar.gz
WORKDIR /opt/volk-2.5.2
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN nproc | xargs -I % make -j%
RUN make install
RUN ldconfig
WORKDIR /opt
RUN rm -r volk-2.5.2

WORKDIR /opt
RUN git clone https://github.com/la1k/libpredict
WORKDIR /opt/libpredict
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN nproc | xargs -I % make -j%
RUN make install
RUN ldconfig
WORKDIR /opt
RUN rm -r libpredict

WORKDIR /opt
RUN git clone https://github.com/altillimity/libdsp
WORKDIR /opt/libdsp
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN nproc | xargs -I % make -j%
RUN make install
RUN ldconfig
WORKDIR /opt
RUN rm -r libdsp



WORKDIR /opt
RUN wget -O satdump.deb https://github.com/SatDump/SatDump/releases/download/1.1.4/satdump_1.1.4_$(dpkg --print-architecture).deb ;\
    dpkg -i satdump.deb;

RUN git clone --depth=1 https://github.com/Digitelektro/MeteorDemod.git
WORKDIR /opt/MeteorDemod
RUN git submodule update --init --recursive
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN nproc | xargs -I % make -j%
RUN make install

WORKDIR /opt
# RUN apt-get install cmake git gcc libsndfile-dev libpng-dev -y
RUN apt-get clean
RUN git clone --recursive https://github.com/Xerbo/aptdec.git
WORKDIR /opt/aptdec
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN nproc | xargs -I % make -j%
RUN make install

WORKDIR /opt
RUN git clone https://github.com/altillimity/AltiWx.git
RUN cd AltiWx
RUN mkdir build
WORKDIR /opt/AltiWx
RUN ls -al
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN nproc | xargs -I % make -j%
RUN mkdir data
RUN mv config.yml config.yml.orig