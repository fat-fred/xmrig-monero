FROM  alpine:latest
RUN   adduser -S -D -H -h /xmrig miner
RUN   apk --no-cache upgrade && \
      apk --no-cache add \
        git \
        cmake \
        build-base \
        libmicrohttpd-dev && \
      git clone https://github.com/xmrig/xmrig && \
      cd xmrig && \
      git checkout v6.7.2 && \
      mkdir build && cd scripts && \
      ./build_deps.sh && cd ../build && \
      cmake .. -DXMRIG_DEPS=scripts/deps -DCMAKE_BUILD_TYPE=Release && \
      make -j$(nproc) && \
      apk del \
        build-base \
        cmake \
        git
USER miner
WORKDIR    /xmrig
COPY config.json /xmrig
EXPOSE 80
ENTRYPOINT  ["./xmrig"]
