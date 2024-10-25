# syntax = docker/dockerfile:experimental

# IMPORTANT: build it this way to allow for privileged execution
#
# Docker daemon config should have the entitlement
# ```json
# { "builder": {"Entitlements": {"security-insecure": true }} }
# ```
# ```
# DOCKER_BUILDKIT=1 docker build --allow security.insecure -t pgpm:local /path/to/pgpm
# ```

FROM fedora:41 AS pgpm

RUN dnf -y install rpmlint ruby ruby-devel mock git gcc zlib-devel
# Pre-initialize mock roots
COPY lib/pgpm/rpm/mock/configs configs
RUN --security=insecure for file in $(find configs -name '*.cfg'); do for ver in "17 16 15 14 13"; \
    do mock --config-opts pgdg_version=$ver $file --init ; done; done


# Pre-initialize gems. It may need an update later, but it'll save us time
RUN mkdir -p /pgpm
COPY lib /pgpm/lib
COPY Gemfile /pgpm
COPY pgpm.gemspec /pgpm
COPY exe /pgpm/exe
RUN chmod +x /pgpm/exe/*
RUN cd /pgpm && gem build && gem install -n /usr/local/bin pgpm*.gem
RUN rm -rf pgpm

COPY containers.conf /etc/containers/containers.conf

ENV QEMU_CPU max


FROM pgpm AS pgpm-dev

COPY . /pgpm
RUN cd /pgpm && bundle install
RUN rm -rf /pgpm

VOLUME /pgpm
WORKDIR /pgpm