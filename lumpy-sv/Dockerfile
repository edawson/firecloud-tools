FROM ubuntu:16.04
MAINTAINER Eric T Dawson
LABEL "tag"="erictdawson/lumpy-sv"

RUN apt-get update &&  apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    gawk \
    gcc-4.9 \
    git \
    libncurses5-dev \
    ldc \
    python-dev \
    python-pip \
    python2.7 \
    tar \
    wget \
    zlib1g-dev

RUN mkdir /app
WORKDIR /app

RUN git clone --recursive https://github.com/samtools/htslib.git
RUN cd htslib && autoheader &&  autoconf && ./configure && make -j 4 && make install
#ENV PATH "/usr/local/lib:/app:$PATH"
#ENV PATH "/usr/local/lib:/app:$LD_LIBRARY_PATH"

RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2
RUN tar xjf samtools-1.3.1.tar.bz2
RUN cd samtools-1.3.1 && make -j 4 && make install

RUN git clone --recursive https://github.com/GregoryFaust/samblaster.git
RUN cd samblaster && make -j 4 && cp samblaster /usr/bin/

RUN pip install pysam numpy
#RUN wget https://github.com/lomereiter/sambamba/releases/download/v0.6.5/sambamba_v0.6.5_linux.tar.bz2 && \
#    tar xjf sambamba_v0.6.5_linux.tar.bz2 && cp sambamba_v0.6.5 /usr/bin/sambamba
RUN git clone --recursive https://github.com/lomereiter/sambamba.git && cd sambamba && make sambamba-ldmd2-64 && cp build/sambamba /usr/bin/

RUN git clone --recursive https://github.com/arq5x/lumpy-sv.git
RUN cd lumpy-sv/ && make -j 4  && cp ./bin/* /usr/bin/
