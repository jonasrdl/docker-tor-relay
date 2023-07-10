FROM ubuntu:20.04

COPY A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc ./
ARG ARCH=amd64

RUN \
  apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install \
    apt-transport-https \
    wget \
    gnupg \
  && printf "deb     [arch=${ARCH} signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org focal main\ndeb-src [arch=${ARCH} signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org focal main" >> /etc/apt/sources.list.d/tor.list \
  && apt-get clean

RUN \
  cat A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null
RUN \
  apt-get update \
  && apt-get -y install tor deb.torproject.org-keyring \
  && apt-get -y remove \
    wget \
  && apt-get clean

COPY entrypoint.sh /
RUN chmod +rx entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
