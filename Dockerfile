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

FROM fedora:41 AS pgpm-rpm

RUN dnf -y install rpmlint ruby ruby-devel mock git gcc zlib-devel
# Pre-initialize mock roots
COPY lib/pgpm/rpm/mock/configs configs
RUN --security=insecure for file in $(find configs -name '*.cfg'); do mock -r $file --init ; done


# Pre-initialize gems. It may need an update later, but it'll save us time
RUN mkdir -p /pgpm
COPY lib /pgpm/lib
COPY Gemfile /pgpm
COPY pgpm.gemspec /pgpm
RUN cd /pgpm && bundle

VOLUME /pgpm
WORKDIR /pgpm