#!/bin/sh
set -e
set -x

echo "Additional configuration for ubuntu boxes"

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  echo "do $PACKER_BUILDER_TYPE specific provisioning"
fi