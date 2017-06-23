#!/bin/bash
set -e

cd $SEAFILE_BIN

# if already installed create symlink and stop processing
if [ $INSTALLED_VERSION != "NONE" ]; then
	cd ${INSTALL_DIR}
	ln -s seafile-pro-server-${SEAFILE_VERSION} seafile-server-latest
	exit 0
fi

# Check if manual setup is desired
if [ $SETUP_MODE != "auto" ]; then

	# Wait until a file in the volume called "installed.flag" exists.
	# This allows the operator to exec into the container to run the interactive setup / configure the files.

	while [ ! -f /tmp/installed.flag ]; do
		sleep 1
	done

	if [ -f /tmp/installed.flag ]; then
		echo "Manual installation created installed.flag, continue startup"
		exit 0
	else
		echo "Installation failed, missing file: ${SEAFILE_DIR}/installed.flag"
		exit 21
	fi	
fi

# print env
echo "Running setup with following configuration:"
echo "==========================================="
printenv | grep -v -E '^INITRD|^PWD|^LANG|^LC_|^OLDPWD|^TERM|^HOSTNAME|^DEBIAN_|^_|^SHLVL'
echo "==========================================="

# modify script to use credentials from env variables instead of asking for them
sed -i 's/= ask_admin_email()/= '"\"${SEAFILE_ADMIN_MAIL}\""'/' ${SEAFILE_BIN}/check_init_admin.py
sed -i 's/= ask_admin_password()/= '"\"${SEAFILE_ADMIN_PASS}\""'/' ${SEAFILE_BIN}/check_init_admin.py

# signal post install scripts to run
echo "set POST_INSTALL_SCRIPTS=1"
POST_INSTALL_SCRIPTS="1"
echo $POST_INSTALL_SCRIPTS > /etc/container_environment/POST_INSTALL_SCRIPTS

if [ $DATABASE_TYPE == "sqlite" ]; then
	echo "sqlite setup ..."
	exec /sbin/setuser seafile $SEAFILE_BIN/setup-seafile.sh auto
elif [ $DATABASE_TYPE == "mysql" ]; then
	echo "mysql setup ..."
	exec /sbin/setuser seafile $SEAFILE_BIN/setup-seafile-mysql.sh auto \
		-n "${SERVER_NAME}" \
		-i "${SERVER_IP}" \
		-d "${SEAFILE_DIR}" \
		-e "0" \
		-o "${MYSQL_HOST}" \
		-t "${MYSQL_PORT}" \
		-r "${MYSQL_ROOT_PASSWD}" \
		-u "${MYSQL_USER}" \
		-w "${MYSQL_USER_PASSWD}" \
		-q "${MYSQL_USER_HOST}" \
		-c "${CCNET_DB}" \
		-s "${SEAFILE_DB}" \
		-b "${SEAHUB_DB}"

else
	echo "Unsupported database type, supported types: [ mysql, sqlite ], was: ${DATABASE_TYPE}"
	exit 22
fi
