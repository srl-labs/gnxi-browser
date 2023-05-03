#!/bin/bash

GRIBI_REPO_DIR=~/openconfig/gribi
GRIBI_DIR=~/openconfig/gribi/v1/proto
YGOT_DIR=~/openconfig/ygot
YGOT_VER=v0.28.2
SERVICE_NAME=gribi
GRIBI_SVC_DIR=${GRIBI_DIR}/service
GRIBI_AFT_DIR=${GRIBI_DIR}/gribi_aft
INTERFACE_FQDN_URL="github.com/openconfig/${SERVICE_NAME}"
PROTO_FILE="${SERVICE_NAME}.proto"

# a map of git references
declare -A gribi_git_refs
gribi_git_refs["v1.0.0"]="0f369fbcc905def3a2e744afb77b5ea4a336b0a2"

# genereate proto docs
function gen-gribi {
    if [ -z "$1" ]; then
        echo "Usage: ./run.sh gen-gribi <version>"
        echo "  where version is like: v1.0.0"
        exit 1
    fi

    OUT_DIR=$(pwd)/src/lib/interfaces/gribi/${SERVICE_NAME}/"$1"
    mkdir -p ${OUT_DIR}

    cd ${YGOT_DIR} && git checkout ${YGOT_VER}


    git_ref=$(_get_git_ref gribi_git_refs "$1")
    echo "checking out to git ref: ${git_ref}"
    cd ${GRIBI_REPO_DIR} && git checkout master && git pull && git checkout ${git_ref}

    DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${GRIBI_AFT_DIR}:/in/v1/proto/gribi_aft \
        -v ${YGOT_DIR}:/in/github.com/openconfig/ygot \
        -v ${GRIBI_SVC_DIR}:/in/${INTERFACE_FQDN_URL} \
        ${IMAGE_NAME}:${IMAGE_TAG}"

    echo "running docker command: ${DOCKER_CMD}"

    ${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
        ${INTERFACE_FQDN_URL}/${PROTO_FILE} \
        v1/proto/gribi_aft/gribi_aft.proto"
    echo "finished Doc compilation for ${PROTO_FILE}"
}