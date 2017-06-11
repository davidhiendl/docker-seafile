#!/bin/bash
set -e

cd $SEAFILE_BIN

# if already installed stop processing
if [ $INSTALLED_VERSION != "NONE" ]; then
	return 0
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
		return 0
	else
		echo "Installation failed, missing file: ${SEAFILE_DIR}/installed.flag"
		return 21
	fi	
fi

# print env
echo "Running setup with following configuration:"
echo "==========================================="
printenv
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
	exec /sbin/setuser seafile $SEAFILE_BIN/setup-seafile-mysql.sh auto
else
	echo "Unsupported database type, supported types: [ mysql, sqlite ], was: ${DATABASE_TYPE}"
	return 22
fi
