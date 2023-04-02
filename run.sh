#!/bin/bash

set -o errexit
set -o pipefail

# container image with protoc and protoc-gen-doc
IMAGE_NAME=ghcr.io/srl-labs/protoc
IMAGE_TAG=22.1__1.28.1

# import path ".:/usr/include" includes the current working dir (/in) and the installed protobuf .proto files that reside in /usr/include
PROTOC_GENDOC_CMD='protoc -I ".:/protobuf/include" --doc_opt=json,proto-doc.json --doc_out=/out'

GNMI_DIR=~/openconfig/gnmi


# gnmi_git_refs is a map of git references to gnmi versions
declare -A gnmi_git_refs
# gnmi_git_refs["v0.9.1"]="some commit hash"

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


# genereate gNMI proto docs
function gen-gnmi {
    OUT_DIR=$(pwd)/static/interfaces/gnmi/gnmi/"$1"
    mkdir -p ${OUT_DIR}

    git_ref=$(_get_git_ref gnmi_git_refs "$1")
    echo "checking out to git ref: ${git_ref}"
    cd ${GNMI_DIR} && git checkout ${git_ref}

    DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${GNMI_DIR}/proto:/in/github.com/openconfig/gnmi/proto \
        ${IMAGE_NAME}:${IMAGE_TAG}"

    ${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
        github.com/openconfig/gnmi/proto/gnmi/gnmi.proto \
        github.com/openconfig/gnmi/proto/gnmi_ext/gnmi_ext.proto"
    echo "finished Doc compilation for gnmi.proto"
}

function help {
  printf "%s <task> [args]\n\nTasks:\n" "${0}"

  compgen -A function | grep -v "^_" | cat -n

  printf "\nExtended help:\n  Each task has comments for general usage\n"
}

# This idea is heavily inspired by: https://github.com/adriancooney/Taskfile
TIMEFORMAT=$'\nTask completed in %3lR'
time "${@:-help}"


set -e