ARG from
FROM ${from}

ARG gcc_version
ENV gcc_version=${gcc_version}

COPY ubuntu/packages.sh /tmp/packages.sh

RUN apt-get -q -y update && \
    apt-get -q -y install --no-install-recommends \
      bc \
      bison \
      bsdmainutils \
      bzip2 \
      ccache \
      file \
      flex \
      gcc \
      git \
      libc-dev \
      libelf-dev \
      liblz4-tool \
      libssl-dev \
      lzop \
      make \
      openssl \
      u-boot-tools \
      rename \
      rsync \
      xz-utils \
      $(/tmp/packages.sh) && \
    rm -rf /var/lib/apt/lists/* /tmp/packages.sh /var/cache/* /var/log/dpkg.log

RUN [ "$gcc_version" = "gcc9" ] && \
        rename -f "s/-9\$//" /usr/bin/powerpc64le-linux-gnu-*-9 && \
        rename -f "s/-9\$//" /usr/bin/powerpc-linux-gnu-*-9 || \
        true

ARG uid
ARG gid

RUN groupadd --gid $gid linuxppc
RUN useradd --uid $uid --gid $gid linuxppc
USER linuxppc

COPY scripts/container-build.sh /bin/container-build.sh
