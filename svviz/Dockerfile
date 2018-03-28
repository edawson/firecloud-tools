FROM ubuntu:16.04
MAINTAINER Eric T Dawson

RUN apt-get update &&  apt-get install -y \
    wget \
    grep \
    git \
    sed \
    build-essential \
    python-dev \
    librsvg2-dev \
    inkscape

WORKDIR /home/

RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O /home/conda.sh

RUN    chmod 777 /home/conda.sh && /bin/bash /home/conda.sh -b -p /opt/conda && \
    rm -rf conda.sh

ENV PATH /opt/conda/bin:$PATH

RUN pip install svviz

ADD maf_svtype.py /usr/bin/
ADD maf_to_svviz.py /usr/bin/

RUN git clone --recursive https://github.com/edawson/LaunChair && cd LaunChair && cp *.py /usr/bin
