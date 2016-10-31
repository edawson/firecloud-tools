FROM ubuntu:14.04
MAINTAINER Eric T Dawson
LABEL "tag"="lumpy-SV"

RUN apt-get update &&  apt-get install -y \
    gcc-4.9 build-essential zlib1g-dev git \
    wget python2.7 tar libncurses5-dev automake autoconf cmake \
    python-dev python-pip

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

RUN git clone --recursive https://github.com/arq5x/lumpy-sv.git
RUN cd lumpy-sv/ && make -j 4  && cp ./bin/* /usr/bin/
