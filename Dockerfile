FROM node:10.5-alpine

ENV NODE_ENV=production

WORKDIR /ddg

RUN apk -U upgrade \
 && apk add \
    git \
    python3 \
    cmake \
    gcc \
    g++ \
    make \
    nginx \
    yarn \
 && rm -rf /var/cache/apk/*

# Installing Emscripten
RUN git clone https://github.com/juj/emsdk.git \
 && cd emsdk \
 && ./emsdk install latest \
 && ./emsdk activate latest \
 && source ./emsdk_env.sh; sync

# Compiling nokiatech/heif to WebAssembly
RUN emcc ./src/libs/heif/srcs/api/common \
 && emcc ./src/libs/heif/srcs/api/reader \
 && emcc ./src/libs/heif/srcs/api/writer
