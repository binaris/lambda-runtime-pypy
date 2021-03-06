#!/bin/bash -e

VERSION=$1

source conf.sh

RUNTIME_ZIP="${PYPY_VERSION}.zip"
MD5SUM=$(type -P md5 && md5 -q $RUNTIME_ZIP || md5sum $RUNTIME_ZIP | awk '{ print $1 }')
S3KEY="${PYPY}/${MD5SUM}.zip"

for region in "${PYPY_REGIONS[@]}"; do
  bucket_name="binaris-layers-${region}"

  echo "Deleting Lambda Layer ${PYPY} version ${VERSION} in region ${region}..."
  aws --region $region lambda delete-layer-version --layer-name ${PYPY} --version-number $VERSION
  echo "Deleted Lambda Layer ${PYPY} version ${VERSION} in region ${region}"
done
