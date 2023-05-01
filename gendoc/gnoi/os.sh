#!/bin/bash

GNOI_DIR=~/openconfig/gnoi
SERVICE_NAME=os
GNOI_SVC_DIR=${GNOI_DIR}/${SERVICE_NAME}
INTERFACE_FQDN_URL="github.com/openconfig/gnoi/${SERVICE_NAME}"
PROTO_FILE="${SERVICE_NAME}.proto"

# a map of git references
declare -A gnoi_os_git_refs
gnoi_os_git_refs["v0.1.1"]="c553e567"
gnoi_os_git_refs["v0.1.4"]="3df08ff738428a3c29db9052011a9b94c0be232b"

# genereate gNMI proto docs
function gen-gnoi-os {
    if [ -z "$1" ]; then
        echo "Usage: ./run.sh gen-gnoi-${SERVICE_NAME} <version>"
        echo "  where version is like: v0.1.1"
        exit 1
    fi

    OUT_DIR=$(pwd)/static/interfaces/gnoi/${SERVICE_NAME}/"$1"
    mkdir -p ${OUT_DIR}

    git_ref=$(_get_git_ref gnoi_os_git_refs "$1")
    echo "checking out to git ref: ${git_ref}"
    cd ${GNOI_SVC_DIR} && git checkout main && git pull && git checkout ${git_ref}

    DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${GNOI_DIR}/types:/in/types \
        -v ${GNOI_SVC_DIR}:/in/${INTERFACE_FQDN_URL} \
        ${IMAGE_NAME}:${IMAGE_TAG}"

    # note that factory_reset.proto imports types.proto as github.com/openconfig/gnoi/types/types.proto
    # and not as types/types.proto. Hence, we need to specify the full path to types.proto
    # this might be needed to be fixed in the future
    ${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
        ${INTERFACE_FQDN_URL}/${PROTO_FILE} \
        types/types.proto"
    echo "finished Doc compilation for ${PROTO_FILE}"
}