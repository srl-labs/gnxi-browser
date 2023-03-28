#!/bin/bash

genProtoDoc() {
  docker run --rm \
  -v $(pwd)/doc:/out \
  -v $(pwd)/$1:/protos \
  --entrypoint '' \
  pseudomuto/protoc-gen-doc \
  bash -c "protoc -I /protos --doc_out=/out /protos/$2.proto --doc_opt=json,proto-doc.json"

  mkdir -p ../$1/$2/v$3
  mv doc/proto-doc.json ../$1/$2/v$3/proto-doc.json
}

if [ $# != 2 ]; then
  echo "No NDK version provided. Usage: bash ./doc/proto-gen.sh <gnmi|gnoi|gnsi> <version>"
  exit 1
fi

# generate proto-doc
for entry in $1/*.proto; do
  protoFile=$(basename $entry)
  protoName=${protoFile%.*}
  genProtoDoc $1 $protoName $2
done
