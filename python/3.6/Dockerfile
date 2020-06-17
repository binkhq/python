FROM ubuntu:20.04

ENV DESTDIR=/tmp/install
ARG PYTHON_VERSION=3.6.10

RUN apt update && DEBIAN_FRONTEND="noninteractive" apt -y install \
    build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev \
    libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev

ADD https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz /tmp/python.tgz

WORKDIR /tmp
RUN tar xzvf python.tgz

WORKDIR /tmp/Python-$PYTHON_VERSION
RUN ./configure --enable-optimizations
RUN make install

WORKDIR /tmp/install/usr/local/bin
RUN ln -s python3 python && \
    ln -s python3-config python-config && \
    ln -s pip3 pip && \
    ln -s idle3 idle

FROM ubuntu:20.04
RUN apt update && apt -y install libssl-dev && apt clean
COPY --from=0 /tmp/install /
