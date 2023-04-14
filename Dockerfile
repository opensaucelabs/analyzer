FROM golang:1.20-bullseye AS builder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git cmake make gcc g++ libssl-dev ca-certificates pkg-config
WORKDIR /app
RUN git clone https://github.com/libgit2/libgit2.git
RUN cd /app/libgit2 && git checkout v1.5.0 && mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTS=false -DUSE_HTTPS=ON && cmake --build . --target install -j 8
COPY banner.txt ./
COPY go.* ./
RUN go mod download
COPY *.go ./
RUN go build
ENTRYPOINT ["/app/analyzer"]