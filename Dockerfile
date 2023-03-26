FROM docker.io/ubuntu:22.04 AS build

ENV DESTDIR=/tmp/install
ARG PYTHON_VERSION=3.11.2
ARG LINKERD_AWAIT_VERSION=0.2.7

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get -y install \
    build-essential checkinstall libreadline-dev libncursesw5-dev \
    libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev \
    libgdbm-dev liblzma-dev wget binutils

RUN wget -O /tmp/python.tgz https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz

WORKDIR /tmp
RUN tar xzvf python.tgz

WORKDIR /tmp/Python-${PYTHON_VERSION}
RUN ./configure --enable-optimizations --enable-loadable-sqlite-extensions \
                --enable-option-checking=fatal --enable-shared \
                --with-system-expat --with-system-ffi
RUN make -j "$(nproc)"
RUN make install

WORKDIR /tmp/install/usr/local/bin
RUN ln -s python3 python && \
    ln -s python3-config python-config && \
    ln -s pip3 pip && \
    rm -fv 2to3 2to3-3.? easy_install-3.? idle3 idle3.? && \
    find /usr/local/ -type f -name '*.pyc' -o -name '*.pyo' -delete
RUN rm -rfv /tmp/install/usr/local/lib/python3.?/test
RUN find . -type f | xargs strip --strip-all | true
RUN wget -O /tmp/install/usr/local/bin/linkerd-await https://github.com/linkerd/linkerd-await/releases/download/release/v${LINKERD_AWAIT_VERSION}/linkerd-await-v${LINKERD_AWAIT_VERSION}-amd64
RUN chmod +x /tmp/install/usr/local/bin/linkerd-await

FROM ubuntu:22.04 AS base
ENV TZ UTC
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl-dev libexpat1 liblzma5 libsqlite3-0 ca-certificates libreadline8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=build /tmp/install /
RUN ldconfig
CMD ["/usr/local/bin/python"]

FROM base AS pipenv
RUN pip install --no-cache-dir pipenv

FROM base AS poetry
RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry self add poetry-dynamic-versioning[plugin] && \
    apt-get update && apt-get -y install git && \
    rm -rf /var/lib/apt/lists/*

FROM base AS pyo3
ARG RUST_VERSION=1.68.1

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get -y install wget gcc libssl-dev pkg-config && \
    wget "https://static.rust-lang.org/rustup/dist/$(uname -m)-unknown-linux-gnu/rustup-init"; \
    chmod +x rustup-init && \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION && \
    rm rustup-init && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME && \
    pip install --no-cache-dir setuptools-rust maturin twine cffi && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
