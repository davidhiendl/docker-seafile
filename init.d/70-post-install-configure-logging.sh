#!/bin/bash
set -e

cd $SEAFILE_BIN

# only run once post-install
if [ $POST_INSTALL_SCRIPTS != "1" ]; then
	return 0
fi


# append settings to existing files
# - enable syslog for seafevents, seafile, seahub
echo "Running post-install: append configuration"

cat /config/seahub_settings.append.py >> $DATA_DIR/conf/seahub_settings.py
cat /config/seafevents.append.conf >> $DATA_DIR/conf/seafevents.conf
cat /config/seafile.append.conf >> $DATA_DIR/conf/seafile.conf

