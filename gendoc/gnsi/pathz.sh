#!/bin/bash

GNOI_DIR=~/openconfig/gnoi
GNSI_DIR=~/openconfig/gnsi
SERVICE_NAME=pathz
GNSI_SVC_DIR=${GNSI_DIR}/${SERVICE_NAME}
GNOI_FQDN="github.com/openconfig/gnoi/"
GNOI_TYPES_FQDN="github.com/openconfig/gnoi/types"
GNSI_VERSION_DIR=${GNSI_DIR}/version
GNSI_VERSION_FQDN="github.com/openconfig/gnsi/version"
INTERFACE_FQDN_URL="github.com/openconfig/gnsi/${SERVICE_NAME}"
GNMI_PATH_PROTO=$(pwd)/gendoc/gnmi/gnmi_path.proto
GNMI_FQDN="github.com/openconfig/gnmi/gnmi.proto"
PROTO_FILE="${SERVICE_NAME}.proto"

# a map of git references
declare -A gnsi_pathz_git_refs
gnsi_pathz_git_refs["v1.0.0"]="6acb1b496c2057d9c61d3f6d96e35e699edab7f4"

# genereate proto docs
function gen-gnsi-pathz {
    if [ -z "$1" ]; then
        echo "Usage: ./run.sh gen-gnsi-${SERVICE_NAME} <version>"
        echo "  where version is like: v1.0.0"
        exit 1
    fi

    OUT_DIR=$(pwd)/src/lib/interfaces/gnsi/${SERVICE_NAME}/"$1"
    mkdir -p ${OUT_DIR}

    git_ref=$(_get_git_ref gnsi_pathz_git_refs "$1")
    echo "checking out to git ref: ${git_ref}"
    cd ${GNSI_SVC_DIR} && git checkout main && git pull && git checkout ${git_ref}

    DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${GNOI_DIR}/types:/in/${GNOI_TYPES_FQDN} \
        -v ${GNSI_VERSION_DIR}:/in/${GNSI_VERSION_FQDN} \
        -v ${GNSI_SVC_DIR}:/in/${INTERFACE_FQDN_URL} \
        -v ${GNMI_PATH_PROTO}:/in/github.com/openconfig/gnmi/proto/gnmi/gnmi.proto \
        ${IMAGE_NAME}:${IMAGE_TAG}"

    echo "running docker command: ${DOCKER_CMD}"

    ${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
        ${INTERFACE_FQDN_URL}/${PROTO_FILE} \
        ${INTERFACE_FQDN_URL}/authorization.proto \
        github.com/openconfig/gnmi/proto/gnmi/gnmi.proto \
        github.com/openconfig/gnsi/version/version.proto"
    echo "finished Doc compilation for ${PROTO_FILE}"
}