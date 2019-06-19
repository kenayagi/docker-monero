FROM debian:stretch-slim

RUN apt update && apt -y upgrade && apt -y install \
    bzip2

ARG UPLOAD_KBPS=1024
ARG DOWNLOAD_KBPS=8192

ARG MONERO_VERSION=v0.14.1.0
ARG MONERO_SHA256SUM=2b95118f53d98d542a85f8732b84ba13b3cd20517ccb40332b0edd0ddf4f8c62

ADD https://downloads.getmonero.org/cli/monero-linux-x64-${MONERO_VERSION}.tar.bz2 /opt/

RUN echo "${MONERO_SHA256SUM}  /opt/monero-linux-x64-${MONERO_VERSION}.tar.bz2" | sha256sum -c

RUN tar -C /opt -xf /opt/monero-linux-x64-${MONERO_VERSION}.tar.bz2
RUN cd /opt && ln -s /opt/monero-x86_64-linux-gnu/ monero

EXPOSE 18080 18081

VOLUME /root/.bitmonero

CMD /opt/monero/monerod --limit-rate-up=${UPLOAD_KBPS} --limit-rate-down=${DOWNLOAD_KBPS} --p2p-bind-ip=0.0.0.0 --p2p-bind-port=18080 --rpc-bind-ip=0.0.0.0 --rpc-bind-port=18081 --non-interactive --confirm-external-bind
