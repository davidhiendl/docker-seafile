#!/bin/bash
set -e

cd $SEAFILE_BIN

# only run once post-install
if [ $POST_INSTALL_SCRIPTS != "1" ]; then
	exit 0
fi

# safe installed version
echo "${SEAFILE_VERSION}" > "${INSTALLED_VERSION_FILE}"

# configure URLs
echo "FILE_SERVER_ROOT = 'https://${SERVER_IP}/seafhttp'" >> $DATA_DIR/conf/seahub_settings.py
sed -i "s|^SERVICE_URL = .*$|SERVICE_URL = https://${SERVER_IP}|" $DATA_DIR/conf/ccnet.conf

# append settings to existing files
# - enable syslog for seafevents, seafile, seahub
echo "Running post-install: append configuration"

cat /config/seahub_settings.append.py >> $DATA_DIR/conf/seahub_settings.py
cat /config/seafevents.append.conf >> $DATA_DIR/conf/seafevents.conf
cat /config/seafile.append.conf >> $DATA_DIR/conf/seafile.conf

