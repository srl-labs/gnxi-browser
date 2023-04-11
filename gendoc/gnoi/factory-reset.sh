GNOI_DIR=~/openconfig/gnoi
GNOI_HEALTHZ_DIR=${GNOI_DIR}/factory_reset
INTERFACE_FQDN_URL="github.com/openconfig/gnoi/factory_reset"
PROTO_FILE="factory_reset.proto"

# gnoi_factoryreset_git_refs is a map of git references
declare -A gnoi_factoryreset_git_refs
gnoi_factoryreset_git_refs["v0.1.0"]="18d7d515"

# genereate gNMI proto docs
function gen-gnoi-factory-reset {
    if [ -z "$1" ]; then
        echo "Usage: ./run.sh gen-gnoi-factory-reset <version>"
        echo "  where version is like: v0.1.0"
        exit 1
    fi

    OUT_DIR=$(pwd)/static/interfaces/gnoi/factory_reset/"$1"
    mkdir -p ${OUT_DIR}

    git_ref=$(_get_git_ref gnoi_factoryreset_git_refs "$1")
    echo "checking out to git ref: ${git_ref}"
    cd ${GNOI_HEALTHZ_DIR} && git checkout main && git pull && git checkout ${git_ref}

    DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${GNOI_DIR}/types:/in/types \
        -v ${GNOI_DIR}/types:/in/github.com/openconfig/gnoi/types \
        -v ${GNOI_HEALTHZ_DIR}:/in/${INTERFACE_FQDN_URL} \
        ${IMAGE_NAME}:${IMAGE_TAG}"

    # note that factory_reset.proto imports types.proto as github.com/openconfig/gnoi/types/types.proto
    # and not as types/types.proto. Hence, we need to specify the full path to types.proto
    # this might be needed to be fixed in the future
    ${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
        ${INTERFACE_FQDN_URL}/${PROTO_FILE} \
        github.com/openconfig/gnoi/types/types.proto"
    echo "finished Doc compilation for ${PROTO_FILE}"
}