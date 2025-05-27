# Stage 0: Build
FROM debian:12-slim

RUN apt-get update
RUN apt-get install -y \
    git curl build-essential libssl-dev zlib1g-dev
ENV COMMIT=ff1bd0059dc8754c0c4a582209e6d64393b0a2b1
RUN git clone https://github.com/GetPageSpeed/MTProxy.git
RUN cd MTProxy && git checkout $COMMIT && make

# Stage 1: Runtime
FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl ca-certificates iproute2 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt

COPY --from=0 /MTProxy/objs/bin/mtproto-proxy /bin

EXPOSE 443 2398
VOLUME /data
WORKDIR /data
ENTRYPOINT /run.sh

COPY run.sh /
