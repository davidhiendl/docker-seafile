#!/bin/bash
set -e

echo "INSTALLED_VERSION=${INSTALLED_VERSION}"
echo "SEAFILE_VERSION=${SEAFILE_VERSION}"

if [ $INSTALLED_VERSION != "NONE" && $INSTALLED_VERSION != $SEAFILE_VERSION ]; then
	echo "ERROR: INSTALLED_VERSION=${INSTALLED_VERSION} does not match SEAFILE_VERSION=${SEAFILE_VERSION} installed in container"
	echo "Manual intervention for upgrade is required."
	exit 31
fi
