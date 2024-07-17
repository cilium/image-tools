FROM registry.access.redhat.com/ubi8:8.9-1136@sha256:bce7e9f69fb7d4533447232478fd825811c760288f87a35699f9c8f030f2c1a6
COPY appstream.repo /etc/yum.repos.d/centos8-appstream.repo
RUN dnf install -y --nodocs make --enablerepo=centos9 --allowerasing
RUN dnf install -y --nodocs gcc --enablerepo=centos9 --allowerasing
RUN curl -L -o iperf.tar.gz https://github.com/esnet/iperf/archive/refs/tags/3.12.tar.gz
RUN curl -L -o netperf.tar.gz https://github.com/HewlettPackard/netperf/archive/80bf19d563eebd1eca23f4092f96819296020fa5.tar.gz
RUN mkdir /iperf && tar xzf iperf.tar.gz --strip-components=1 -C /iperf
RUN mkdir /netperf && tar xzf netperf.tar.gz --strip-components=1 -C /netperf
WORKDIR /iperf
RUN ./configure && make && make install
WORKDIR /netperf
RUN ./configure && make && make install
RUN rm -rf /iperf /iperf.tar.gz
RUN rm -rf /netperf /netperf.tar.gz
RUN dnf remove -y gcc make
