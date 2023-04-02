#!/bin/bash

set -o errexit
set -o pipefail

# container image with protoc and protoc-gen-doc
IMAGE_NAME=ghcr.io/srl-labs/protoc
IMAGE_TAG=22.1__1.28.1

# import path ".:/usr/include" includes the current working dir (/in) and the installed protobuf .proto files that reside in /usr/include
PROTOC_GENDOC_CMD='protoc -I ".:/protobuf/include:/googleapis" --doc_opt=json,proto-doc.json --doc_out=/out'

# get_git_ref returns the git reference from a passed array for a given version
# it returns the version if no git reference is found in the passed array
_get_git_ref() {
  local array="$1"
  local version="$2"
  local ref
  eval "ref=\${$array[\$version]}" # this is a bit of a hack to get the value from the array passed as a variable
  if [[ -n "$ref" ]]; then
    echo "$ref"
  else
    echo "$version"
  fi
}


source ./gendoc/gnmi/gnmi.sh
source ./gendoc/gnoi/packet-link-qual.sh

function help {
  printf "%s <task> [args]\n\nTasks:\n" "${0}"

  compgen -A function | grep -v "^_" | cat -n

  printf "\nExtended help:\n  Each task has comments for general usage\n"
}

# This idea is heavily inspired by: https://github.com/adriancooney/Taskfile
TIMEFORMAT=$'\nTask completed in %3lR'
time "${@:-help}"


set -e