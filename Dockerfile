# use ubuntu as base image
FROM ubuntu AS builder
# install packages
RUN : \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gcc libc6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# copy "hello_world.c" from current directory to builder container
COPY hello_world.c .
# compile "hello_world.c" source code and generate "hello" binary executable file
RUN gcc -static -o /tmp/hello hello_world.c

# create final image from scratch
FROM scratch AS final
# copy "/etc/passwd" from builder to final container
COPY --from=builder /etc/passwd /etc/passwd
# copy "hello" binary executable to new container
COPY --from=builder /tmp/hello /tmp/hello
# change user to nobody
USER nobody
# execute "hello" binary
ENTRYPOINT  ["/tmp/hello"]
