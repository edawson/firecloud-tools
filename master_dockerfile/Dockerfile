FROM ubuntu:16.04
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

RUN git clone --recursive https://github.com/samtools/htslib.git
RUN cd htslib && autoheader &&  autoconf && ./configure && make -j 4 && make install
ENV PATH="/usr/local/lib:/app:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/lib:/app:$LD_LIBRARY_PATH"

RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2
RUN tar xjf samtools-1.3.1.tar.bz2
RUN cd samtools-1.3.1 && make -j 4 && make install

RUN git clone --recursive https://github.com/GregoryFaust/samblaster.git
RUN cd samblaster && make -j 4 && cp samblaster /usr/bin/

#RUN wget https://github.com/lomereiter/sambamba/releases/download/v0.6.5/sambamba_v0.6.5_linux.tar.bz2 && \
#    tar xjf sambamba_v0.6.5_linux.tar.bz2 && cp sambamba_v0.6.5 /usr/bin/sambamba
##RUN git clone --recursive https://github.com/lomereiter/sambamba.git && cd sambamba && make sambamba-ldmd2-64 && cp build/sambamba /usr/bin/
RUN wget https://github.com/lomereiter/sambamba/releases/download/v0.6.6/sambamba_v0.6.6_linux.tar.bz2 && tar xvjf sambamba_v0.6.6_linux.tar.bz2 && mv sambamba_v0.6.6 /usr/bin/sambamba

RUN pip install pysam numpy && wget https://github.com/arq5x/lumpy-sv/releases/download/0.2.13/lumpy-sv-v0.2.13.tar.gz && tar xvzf lumpy-sv-v0.2.13.tar.gz && cd lumpy-sv-v0.2.13 && make && cp ./bin/* /usr/bin/
## && git clone --recursive https://github.com/edawson/lumpy-sv.git && cd lumpy-sv/ && make  && cp ./bin/* /usr/bin/

RUN wget https://github.com/dellytools/delly/releases/download/v0.7.8/delly_v0.7.8_parallel_linux_x86_64bit && mv delly_v0.7.8_parallel_linux_x86_64bit /usr/bin/delly && chmod 777 /usr/bin/delly

RUN wget https://github.com/nygenome/lancet/archive/v1.0.6.tar.gz && tar xvzf v1.0.6.tar.gz && cd lancet-1.0.6 && make && cp src/lancet /usr/bin/

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

RUN git clone --recursive https://github.com/edawson/freebayes && cd freebayes && make && cp scripts/* /usr/bin/

RUN git clone --recursive https://github.com/edawson/LaunChair

RUN wget https://github.com/Illumina/manta/releases/download/v1.2.0/manta-1.2.0.release_src.tar.bz2 && tar xvjf manta-1.2.0.release_src.tar.bz2 && mkdir build && cd build && ../manta-1.2.0.release_src/configure --jobs=1 --prefix=/usr/bin && make install

RUN wget https://github.com/Illumina/strelka/releases/download/v2.8.3/strelka-2.8.3.release_src.tar.bz2 && tar xvjf strelka-2.8.3.release_src.tar.bz2 && mkdir -p build && cd build && rm -rf ./* && ../strelka-2.8.3.release_src/configure --jobs=1 --prefix=/usr/bin && make install


RUN git clone --recursive https://github.com/edawson/bamcov && \
    cd bamcov && \
    chmod 777 bamcov_known.sh && cp bamcov_known.sh /usr/bin

RUN alias awk="gawk"

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.27.1/bedtools-2.27.1.tar.gz && tar xvzf bedtools-2.27.1.tar.gz && cd bedtools2 && make -j 4 && make install

RUN git clone --recursive https://github.com/edawson/maf_to_bed.git && cp maf_to_bed/*.py /usr/bin

RUN pip install pysam==0.10

RUN git clone --recursive https://github.com/edawson/telomerecat && cd telomerecat && python setup.py build && python setup.py install

RUN git clone --recursive https://github.com/dillonl/graphite.git && cd graphite && mkdir build && cd build && cmake .. && make && make install

RUN git clone --recursive https://github.com/pezmaster31/bamtools && cd bamtools && mkdir build && cd build && cmake .. && make && make install
RUN git clone --recursive https://github.com/edawson/telseq && cd telseq && cd src && ./autogen.sh && ./configure --with-bamtools=/usr/local && make && make install

RUN wget https://github.com/brentp/mosdepth/releases/download/v0.2.3/mosdepth && chmod 777 mosdepth && mv mosdepth /usr/local/bin

ADD vcfsort.sh /usr/local/bin/

RUN cp /app/freebayes/bin/freebayes /usr/local/bin && chmod 777 /usr/local/bin/freebayes
