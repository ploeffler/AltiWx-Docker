FROM debian:buster-slim
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install libspdlog-dev librtlsdr-dev libfmt-dev pybind11-dev python3-dev libliquid-dev cmake build-essential git libvolk1-dev libyaml-cpp-dev -y

WORKDIR /opt
RUN git clone https://github.com/la1k/libpredict
WORKDIR /opt/libpredict
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN make
RUN make install

WORKDIR /opt
RUN git clone https://github.com/altillimity/libdsp
WORKDIR /opt/libdsp
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN make
RUN make install

WORKDIR /opt
RUN git clone https://github.com/altillimity/AltiWx.git
RUN cd AltiWx
RUN mkdir build
WORKDIR /opt/AltiWx
RUN ls -al
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN make
RUN mkdir data
RUN mv config.yml config.yml.orig
