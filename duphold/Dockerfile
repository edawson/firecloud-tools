from ubuntu:16.04
MAINTAINER Eric T Dawson

RUN apt-get update &&  apt-get install -y \
        autoconf \
        automake \
        bc \
        bsdmainutils \
        build-essential \
        cmake \
        dstat \
        gawk \
        gcc-4.9 \
        git \
        gnupg \
        libcurl4-gnutls-dev \
        libssl-dev \
        libncurses5-dev \
        libbz2-dev \
        liblzma-dev \
        ldc \
        python-dev \
        python-pip \
        python2.7 \
        tar \
        wget \
        zlib1g-dev \
        zlib1g

RUN mkdir /app
WORKDIR /app

RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 && tar xvjf htslib-1.9.tar.bz2 && \
    cd htslib-1.9 && autoheader &&  autoconf && ./configure && make -j 4 && make install
ENV PATH="/usr/local/lib:/app:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/lib:/app:$LD_LIBRARY_PATH"
RUN wget https://github.com/brentp/duphold/releases/download/v0.0.2/duphold && chmod 777 duphold && mv duphold /usr/local/bin/
