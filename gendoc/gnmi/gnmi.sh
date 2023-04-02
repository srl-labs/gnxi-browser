GNMI_DIR=~/openconfig/gnmi

# gnmi_git_refs is a map of git references to gnmi versions
declare -A gnmi_git_refs
# gnmi_git_refs["v0.9.1"]="some commit hash"

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