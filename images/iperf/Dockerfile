FROM registry.access.redhat.com/ubi8:8.5

COPY appstream.repo /etc/yum.repos.d/centos8-appstream.repo
RUN dnf install -y --nodocs iperf3 --enablerepo=centos9-appstream --enablerepo=centos9
RUN dnf install -y --nodocs tcpdump --enablerepo=centos9-appstream --enablerepo=centos9
RUN dnf install -y --nodocs procps-ng iproute net-tools ethtool nmap iputils bind-utils
