FROM ubuntu:16.04
MAINTAINER Eric T Dawson

RUN apt-get update && apt-get install -yy \
    bzip2 \
    gcc-4.9 \
    tar \
    vowpal-wabbit \
    wget 

RUN mkdir /app
WORKDIR /app

RUN wget https://github.com/lomereiter/sambamba/releases/download/v0.6.5/sambamba_v0.6.5_linux.tar.bz2
RUN tar xjf /app/sambamba_v0.6.5_linux.tar.bz2
RUN mv /app/sambamba_v0.6.5 /bin/sambamba
RUN echo '<${2} xargs -n 1 -P 4 -tl -i{} sambamba slice -o {}.slice.bam ${1} {}' > /app/parallel_slice_helper.sh && \
    chmod 777 /app/parallel_slice_helper.sh && mv /app/parallel_slice_helper.sh /bin/
