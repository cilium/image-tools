FROM registry.access.redhat.com/ubi8/ubi@sha256:0c1757c4526cfd7fdfedc54fadf4940e7f453201de65c0fefd454f3dde117273
RUN dnf install -y --nodocs gcc make
RUN curl -L -o iperf.tar.gz https://github.com/esnet/iperf/archive/refs/tags/3.19.tar.gz
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
