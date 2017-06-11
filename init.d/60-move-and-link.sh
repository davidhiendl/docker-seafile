#!/bin/bash
set -e

# WARNING: this has to run AFTER setup scripts to allow it to move newly created configurations into to volume

# move from INSTALL_DIR to DATA_DIR
for TARGET_DIR in "ccnet" "conf" "seafile-data" "seahub-data" "pro-data"
do
	if [ -e "${INSTALL_DIR}/${TARGET_DIR}" -a ! -L "${BASEPATH}/${TARGET_DIR}" ]
	then
		echo "moving: ${INSTALL_DIR}/${TARGET_DIR} -> ${DATA_DIR}/${TARGET_DIR}"
		mv ${INSTALL_DIR}/${TARGET_DIR} ${DATA_DIR}
	fi
done

if [ -e "${INSTALL_DIR}/seahub.db" -a ! -L "${INSTALL_DIR}/seahub.db" ]
then
	echo "moving: ${INSTALL_DIR}/seahub.db -> ${DATA_DIR}/seahub.db"
	mv ${INSTALL_DIR}/seahub.db ${DATA_DIR}/
fi


# symlink from DATA_DIR to INSTALL_DIR
for TARGET_DIR in "ccnet" "conf" "seafile-data" "seahub-data" "pro-data"
do
	if [ -e "${DATA_DIR}/${TARGET_DIR}" ]
	then
		echo "linking: ${INSTALL_DIR}/${TARGET_DIR} -> ${DATA_DIR}/${TARGET_DIR}"
		ln -sf ${DATA_DIR}/${TARGET_DIR} ${INSTALL_DIR}/${TARGET_DIR}
		chown -h seafile:seafile ${INSTALL_DIR}/${TARGET_DIR}
	fi
done

if [ -e "${DATA_DIR}/seahub.db" -a ! -L "${DATA_DIR}/seahub.db" ]
then
	echo "linking: ${INSTALL_DIR}/seahub.db -> ${DATA_DIR}/seahub.db"
	ln -fs ${DATA_DIR}/seahub.db ${INSTALL_DIR}/seahub.db
	chown -h seafile:seafile ${INSTALL_DIR}/seahub.db
fi
