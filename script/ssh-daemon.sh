#! /bin/bash
set -e

# Set environment variables
SSH_HOST_KEY_FILE=${SSH_HOST_KEY_FILE:-/etc/ssh/ssh_host_rsa_key}

# Generate an SSH key if none is present
if ! [ -f "${SSH_HOST_KEY_FILE}" ]; then
  ssh-keygen -t rsa -b 4096 -f "${SSH_HOST_KEY_FILE}" -N '' -C ''
fi

command="/usr/sbin/sshd -D"
if [ "${SSH_DEBUG_LEVEL}" = "1" ]; then
  command="$command -d -e"
fi
if [ "${SSH_DEBUG_LEVEL}" = "2" ]; then
  command="$command -d -d -e"
fi
if [ "${SSH_DEBUG_LEVEL}" = "3" ]; then
  command="$command -d -d -d -e"
fi
command="$command -h ${SSH_HOST_KEY_FILE}"

$command
