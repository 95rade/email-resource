#!/bin/bash -e

mkdir ~/.ssh/ && touch ~/.ssh/known_hosts
ssh-keyscan github.com >>~/.ssh/known_hosts

export GOPATH=$PWD/go
export PATH=$GOPATH/bin:$PATH
OUTPUT_DIR=$PWD/compiled-output
SOURCE_DIR=$PWD/source

cp source/Dockerfile ${OUTPUT_DIR}/.
cp /etc/ssl/certs/ca-certificates.crt ${OUTPUT_DIR}/ca-certificates.crt

go get github.com/tools/godep
go get github.com/xchapter7x/versioning

cd ${SOURCE_DIR}
DRAFT_VERSION=`versioning bump_patch`-`git rev-parse HEAD`
echo "next version should be: ${DRAFT_VERSION}"

WORKING_DIR=$GOPATH/src/github.com/pivotal-cf/email-resource
mkdir -p ${WORKING_DIR}
cp -R source/* ${WORKING_DIR}/.
cd ${WORKING_DIR}
godep go build -o ${OUTPUT_DIR}/bin/check ./actions/check
godep go build -o ${OUTPUT_DIR}/bin/in ./actions/in
godep go build -o ${OUTPUT_DIR}/bin/out -ldflags "-X main.VERSION=${DRAFT_VERSION}" ./actions/out

echo ${DRAFT_VERSION} > ${OUTPUT_DIR}/name
echo ${DRAFT_VERSION} > ${OUTPUT_DIR}/tag
