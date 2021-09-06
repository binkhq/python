FROM ghcr.io/binkhq/python:3.9

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    DEBIAN_FRONTEND="noninteractive"

ARG RUST_VERSION=1.54.0

RUN apt-get update && \
    apt-get -y install wget gcc libssl-dev pkg-config && \
    wget "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" && \
    chmod +x rustup-init && \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION && \
    rm rustup-init && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME && \
    pip install --no-cache-dir setuptools-rust maturin twine cffi && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
