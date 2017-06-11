#!/bin/bash
set -e

groupadd seafile \
	-r \
	-g $SEAFILE_GID

useradd seafile \
	-r \
	-s /bin/bash \
	-M \
	-u $SEAFILE_UID \
	-g $SEAFILE_GID \
	-d $INSTALL_DIR

# change owner of $INSTALL_DIR to allow seafile user to create configuration
chown seafile:seafile \
	$INSTALL_DIR \
	$INSTALL_DIR/*

# fix permission errors during seahub startup (seahub is moving some files around)
chown -R seafile:seafile \
	$SEAFILE_BIN/seahub/media
