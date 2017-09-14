FROM ubuntu:16.04
MAINTAINER Eric T Dawson
LABEL "tag"="erictdawson/lumpy-sv"

RUN apt-get update &&  apt-get install -y \
    autoconf \
    automake \
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
##RUN git clone --recursive https://github.com/lomereiter/sambamba.git && cd sambamba && make sambamba-ldmd2-64 && cp build/sambamba /usr/bin/
RUN wget https://github.com/lomereiter/sambamba/releases/download/v0.6.6/sambamba_v0.6.6_linux.tar.bz2 && tar xvjf sambamba_v0.6.6_linux.tar.bz2 && mv sambamba_v0.6.6 /usr/bin/sambamba

RUN git clone --recursive https://github.com/arq5x/lumpy-sv.git && cd lumpy-sv/ && make  && cp ./bin/* /usr/bin/

#RUN git clone --recursive https://github.com/dellytools/delly.git && cd delly && make PARALLEL=1 -B src/delly && cp src/delly /usr/bin
RUN wget https://github.com/dellytools/delly/releases/download/v0.7.7/delly_v0.7.7_parallel_linux_x86_64bit && mv delly_v0.7.7_parallel_linux_x86_64bit /usr/bin/delly

RUN git clone git://github.com/nygenome/lancet.git && cd lancet && make && cp src/lancet /usr/bin/

RUN git clone --recursive https://github.com/vgteam/vcflib && \
    cd vcflib && \
    make && cp bin/* /usr/bin

RUN wget https://github.com/samtools/bcftools/releases/download/1.4/bcftools-1.4.tar.bz2 && tar xfj bcftools-1.4.tar.bz2 && cd bcftools-1.4 make -j 4 && make install

RUN wget https://pypi.python.org/packages/cf/41/636795b48c84fb8331710e9f6e948b2b9d0a3123c7fdaac62b061411de0a/telomerehunter-1.0.4.tar.gz && tar xvzf telomerehunter-1.0.4.tar.gz && \
    cd telomerehunter-1.0.4/ && python setup.py build && python setup.py install

RUN wget https://downloads.sourceforge.net/project/integrate-fusion/INTEGRATE.0.2.6.tar.gz && \
    tar xvzf INTEGRATE.0.2.6.tar.gz && cd INTEGRATE_0_2_6/Integrate && cmake . && make && cp bin/Integrate /usr/bin/

RUN git clone --recursive https://github.com/zeeev/wham && cd wham && make && cp /app/wham/bin/whamg /usr/bin/

RUN git clone --recursive https://github.com/lh3/fermikit.git && cd fermikit && make

RUN git clone --recursive https://github.com/walaj/svaba.git && cd svaba && ./configure && make && make install && cp bin/svaba /usr/bin

RUN git clone --recursive https://github.com/lh3/bwa && cd bwa && make && cp bwa /usr/bin

RUN wget http://ftp.gnu.org/gnu/parallel/parallel-20170722.tar.bz2 && tar xvjf parallel-20170722.tar.bz2 && cd parallel-20170722 && ./configure && make && make install

RUN git clone --recursive https://github.com/edawson/freebayes && cd freebayes && make && make install && cd vcflib && make && cp bin/* /usr/bin && cd ../ && cp scripts/* /usr/bin/

RUN git clone --recursive https://github.com/edawson/LaunChair

ENTRYPOINT /bin/bash

#RUN git clone --recursive https://github.com/arq5x/lumpy-sv && cd lumpy-sv && make && make install
