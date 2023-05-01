GNOI_DIR=~/openconfig/gnoi
GNOI_HEALTHZ_DIR=${GNOI_DIR}/healthz
INTERFACE_FQDN_URL="github.com/openconfig/gnoi/healthz"
PROTO_FILE="healthz.proto"

# gnoi_healthz_git_refs is a map of git references to gnoi healthz versions
declare -A gnoi_healthz_git_refs
gnoi_healthz_git_refs["v1.3.0"]="4f5cb088"

# genereate gNMI proto docs
function gen-gnoi-healthz {
    if [ -z "$1" ]; then
        echo "Usage: ./run.sh gen-gnoi-healthz <version>"
        echo "  where version is like: v1.3.0"
        exit 1
    fi

    OUT_DIR=$(pwd)/static/interfaces/gnoi/healthz/"$1"
    mkdir -p ${OUT_DIR}

    git_ref=$(_get_git_ref gnoi_healthz_git_refs "$1")
    echo "checking out to git ref: ${git_ref}"
    cd ${GNOI_HEALTHZ_DIR} && git checkout main && git pull && git checkout ${git_ref}

    # types are required for healthz.proto
    DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${GNOI_DIR}/types:/in/types \
        -v ${GNOI_HEALTHZ_DIR}:/in/${INTERFACE_FQDN_URL} \
        ${IMAGE_NAME}:${IMAGE_TAG}"

    ${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
        ${INTERFACE_FQDN_URL}/${PROTO_FILE} \
        google/protobuf/any.proto \
        google/protobuf/timestamp.proto \
        types/types.proto"
    echo "finished Doc compilation for ${PROTO_FILE}"
}