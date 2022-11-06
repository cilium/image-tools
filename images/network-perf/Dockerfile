FROM registry.access.redhat.com/ubi8:8.6
COPY appstream.repo /etc/yum.repos.d/centos8-appstream.repo
RUN dnf install -y --nodocs make --enablerepo=centos9 --allowerasing
RUN dnf install -y --nodocs gcc --enablerepo=centos9 --allowerasing
RUN curl -L -o iperf.tar.gz https://github.com/esnet/iperf/archive/refs/tags/3.12.tar.gz
RUN mkdir /iperf && tar xzf iperf.tar.gz --strip-components=1 -C /iperf
RUN curl -LO https://github.com/HewlettPackard/netperf/archive/refs/tags/netperf-2.7.0.tar.gz
RUN tar -xzf netperf-2.7.0.tar.gz
WORKDIR /iperf
RUN ./configure && make && make install
WORKDIR /netperf-netperf-2.7.0
RUN ./configure && make && make install
RUN rm -rf /iperf /iperf.tar.gz
RUN rm -rf /netperf-2.7.0.tar.gz /netperf-netperf-2.7.0
RUN dnf remove -y gcc make
