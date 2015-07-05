#
# Docker ambassador pattern linking docker image
#
# http://github.com/tenstartups/ambassador-docker
#

FROM alpine:latest

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment variables.
ENV \
  TERM=xterm-color

# Install packages.
RUN \
  apk --update add bash build-base nano openssh socat sshpass wget && \
  rm /var/cache/apk/*

# Compile autossh from source.
RUN \
  wget http://www.harding.motd.ca/autossh/autossh-1.4e.tgz && \
  tar -xzf autossh-*.tgz && \
  cd autossh-* && \
  ./configure && \
  make && \
  make install

# Define working directory.
WORKDIR /root

# Add files to the container.
ADD . /root

# Copy scripts and configuration into place.
RUN \
  mkdir /root/.ssh && \
  chmod 700 /root/.ssh && \
  find ./script -type f -name '*.sh' | while read f; do echo "$f -> /usr/local/bin/`basename ${f%.sh}`"; cp "$f" "/usr/local/bin/`basename ${f%.sh}`"; done && \
  rm -rf ./script

# Set the entrypoint script.
ENTRYPOINT ["./entrypoint"]

# Expose ports.
EXPOSE 22
