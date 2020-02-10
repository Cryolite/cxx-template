FROM ubuntu AS build-prerequisites

RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  g++ \
  git \
  gnupg \
  less \
  libssl-dev \
  make \
  python3 \
  python3-distutils \
  texinfo \
  xz-utils \
  && rm -rf /var/lib/apt/lists/*
