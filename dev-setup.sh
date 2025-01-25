#!/bin/bash

check_os() {
  local DISTRIBUTION=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g' | sed -e 's/"//g')
  local VERSION=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g' | sed -e 's/"//g')
  if [[ ${DISTRIBUTION} != 'fedora' || ${VERSION}  < 41 ]]; then
    echo "Invalid OS"
    exit 1
  fi
  bash "./${DISTRIBUTION}/${VERSION}/scripts.sh" $#
}

check_os