FROM fedora:41 AS pgpm-rpm

RUN dnf -y install rpmlint ruby ruby-devel mock git gcc zlib-devel
VOLUME /pgpm
WORKDIR /pgpm