FROM ubuntu:16.04
MAINTAINER Eric T Dawson

RUN apt-get update && apt-get install -yy gcc-4.9 wget tar bzip2

RUN mkdir /app
WORKDIR /app

RUN wget https://github.com/lomereiter/sambamba/releases/download/v0.6.5/sambamba_v0.6.5_linux.tar.bz2
RUN tar xjf /app/sambamba_v0.6.5_linux.tar.bz2
RUN mv /app/sambamba_v0.6.5 /bin/sambamba
