FROM debian:stretch-slim

RUN apt update && apt -y upgrade && apt -y install \
    bzip2

ARG MONERO_VERSION=v0.14.0.2
ARG MONERO_SHA256SUM=4dd5cd9976eda6b33b16821e79e671527b78a1c9bfb3d973efe84b824642dd21

ADD https://downloads.getmonero.org/cli/monero-linux-x64-${MONERO_VERSION}.tar.bz2 /opt/

RUN echo "${MONERO_SHA256SUM}  /opt/monero-linux-x64-${MONERO_VERSION}.tar.bz2" | sha256sum -c

RUN tar -C /opt -xf /opt/monero-linux-x64-${MONERO_VERSION}.tar.bz2
RUN cd /opt && ln -s /opt/monero-${MONERO_VERSION}/ monero

EXPOSE 18080 18081

VOLUME /root/.bitmonero

CMD /opt/monero/monerod --p2p-bind-ip=0.0.0.0 --p2p-bind-port=18080 --rpc-bind-ip=0.0.0.0 --rpc-bind-port=18081 --non-interactive --confirm-external-bind
