GNOI_DIR=~/openconfig/gnoi
GNOI_PLQ_DIR=${GNOI_DIR}/packet_link_qualification

# gnoi_plq_git_refs is a map of git references to gnoi packet link qualification versions
declare -A gnoi_plq_git_refs
gnoi_plq_git_refs["v1.1.0"]="3e721f3"

# genereate gNMI proto docs
function gen-gnoi-packet-link-qual {
    OUT_DIR=$(pwd)/static/interfaces/gnoi/packet_link_qualification/"$1"
    mkdir -p ${OUT_DIR}

    git_ref=$(_get_git_ref gnoi_plq_git_refs "$1")
    echo "checking out to git ref: ${git_ref}"
    cd ${GNOI_PLQ_DIR} && git checkout main && git pull && git checkout ${git_ref}

    # types are required for packet_link_qualification.proto
    DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${GNOI_DIR}/types:/in/types \
        -v ${GNOI_PLQ_DIR}:/in/github.com/openconfig/gnoi/packet_link_qualification \
        ${IMAGE_NAME}:${IMAGE_TAG}"

    ${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
        github.com/openconfig/gnoi/packet_link_qualification/packet_link_qualification.proto \
        google/protobuf/duration.proto \
        google/protobuf/timestamp.proto \
        google/rpc/status.proto \
        types/types.proto"
    echo "finished Doc compilation for packet_link_qualification.proto"
}