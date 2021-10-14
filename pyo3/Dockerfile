ARG PYTHON_VERSION=3.10
FROM ghcr.io/binkhq/python:${PYTHON_VERSION}

ARG RUST_VERSION=1.55.0

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
