#!/bin/bash

GNOI_DIR=~/openconfig/gnoi
SERVICE_NAME=file
GNOI_SVC_DIR=${GNOI_DIR}/${SERVICE_NAME}
INTERFACE_FQDN_URL="github.com/openconfig/gnoi/${SERVICE_NAME}"
PROTO_FILE="${SERVICE_NAME}.proto"

# a map of git references
declare -A gnoi_file_git_refs
gnoi_file_git_refs["v0.1.0"]="c553e567c5f917bc349952ea47b2c4df854962c9"

# genereate gNMI proto docs
function gen-gnoi-file {
    if [ -z "$1" ]; then
        echo "Usage: ./run.sh gen-gnoi-${SERVICE_NAME} <version>"
        echo "  where version is like: v0.1.0"
        exit 1
    fi

    OUT_DIR=$(pwd)/src/lib/interfaces/gnoi/${SERVICE_NAME}/"$1"
    mkdir -p ${OUT_DIR}

    git_ref=$(_get_git_ref gnoi_file_git_refs "$1")
    echo "checking out to git ref: ${git_ref}"
    cd ${GNOI_SVC_DIR} && git checkout main && git pull && git checkout ${git_ref}

    DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${GNOI_DIR}/types:/in/types \
        -v ${GNOI_DIR}/common:/in/common \
        -v ${GNOI_SVC_DIR}:/in/${INTERFACE_FQDN_URL} \
        ${IMAGE_NAME}:${IMAGE_TAG}"

    ${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
        ${INTERFACE_FQDN_URL}/${PROTO_FILE} \
        common/common.proto \
        types/types.proto"
    echo "finished Doc compilation for ${PROTO_FILE}"
}