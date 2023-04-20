ARG GOLANG_VERSION=1.20
FROM golang:${GOLANG_VERSION}-bullseye as builder

ARG VIPS_VERSION=8.14.1
ARG CGIF_VERSION=0.3.0
ARG LIBSPNG_VERSION=0.7.3

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# libaom3 is in Debian bullseye-backports 
RUN echo 'deb http://deb.debian.org/debian bullseye-backports main' > /etc/apt/sources.list.d/backports.list

# Installs libvips + required libraries
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y \
  ca-certificates \
  automake build-essential curl \
  python3-pip ninja-build pkg-config \
  gobject-introspection gtk-doc-tools libglib2.0-dev libjpeg62-turbo-dev libpng-dev \
  libwebp-dev libtiff5-dev libexif-dev libxml2-dev libpoppler-glib-dev \
  swig libpango1.0-dev libmatio-dev libopenslide-dev libcfitsio-dev libopenjp2-7-dev \
  libgsf-1-dev fftw3-dev liborc-0.4-dev librsvg2-dev libimagequant-dev libaom-dev/bullseye-backports libheif-dev && \
  pip3 install meson && \
  cd /tmp && \
  curl -fsSLO https://github.com/dloebl/cgif/archive/refs/tags/V${CGIF_VERSION}.tar.gz && \
  tar xf V${CGIF_VERSION}.tar.gz && \
  cd cgif-${CGIF_VERSION} && \
  meson build --prefix=/usr/local --libdir=/usr/local/lib --buildtype=release && \
  cd build && \
  ninja && \
  ninja install && \
  cd /tmp && \
  curl -fsSLO https://github.com/randy408/libspng/archive/refs/tags/v${LIBSPNG_VERSION}.tar.gz && \
  tar xf v${LIBSPNG_VERSION}.tar.gz && \
  cd libspng-${LIBSPNG_VERSION} && \
  meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib && \
  ninja -C _build && \
  ninja -C _build install && \
  cd /tmp && \
  curl -fsSLO https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz && \
  tar xf vips-${VIPS_VERSION}.tar.xz && \
  cd vips-${VIPS_VERSION} && \
  meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  -Dgtk_doc=false \
  -Dmagick=disabled \
  -Dintrospection=false && \
  ninja -C _build && \
  ninja -C _build install && \
  ldconfig && \
  rm -rf /usr/local/lib/python* && \
  rm -rf /usr/local/lib/libvips-cpp.* && \
  rm -rf /usr/local/lib/*.a && \
  rm -rf /usr/local/lib/*.la

WORKDIR ${GOPATH}/src/github.com/nestor-sk/vimgo

RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.50.1

COPY go.mod .
RUN go mod download

COPY . .
RUN go build .

CMD [ "/bin/bash" ]