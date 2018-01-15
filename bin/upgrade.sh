#!/bin/bash

echo "Not yet supported"
exit 1;

# Get versions.
CURRENT_VERSION=$(ls -lah | grep 'seafile-server-latest' | awk -F"seafile-pro-server-" '{print $2}')
NEW_VERSION=$SEAFILE_VERSION

# Check if any upgrade is available
echo "Checking if there is an update available ..."
if [ "$CURRENT_VERSION" == "$NEW_VERSION" ]; then
	echo "[FAILED] You already have the most recent version installed"
	exit 0
fi

# First we need to check if it's a maintenance update, since the process is different from a major/minor version upgrade
CURRENT_MAJOR_VERSION=$(echo $CURRENT_VERSION | awk -F"." '{print $1}')
CURRENT_MINOR_VERSION=$(echo $CURRENT_VERSION | awk -F"." '{print $2}')
CURRENT_MAINTENANCE_VERSION=$(echo $CURRENT_VERSION | awk -F"." '{print $3}')

NEW_MAJOR_VERSION=$(echo $NEW_VERSION | awk -F"." '{print $1}')
NEW_MINOR_VERSION=$(echo $NEW_VERSION | awk -F"." '{print $2}')
NEW_MAINTENANCE_VERSION=$(echo $NEW_VERSION | awk -F"." '{print $3}')

if [ "$CURRENT_MAJOR_VERSION" == "$NEW_MAJOR_VERSION" ] && [ "$CURRENT_MINOR_VERSION" == "$NEW_MINOR_VERSION" ]; then
  # Alright, this is only a maintenance update.
  echo "Performing minor upgrade ..."
  ./upgrade/minor-upgrade.sh
  cd /seafile
  rm -rf "/seafile/seafile-pro-server-${CURRENT_VERSION}"
else
  # Big version jump
  for file in ./upgrade/upgrade_*.sh
  do
    UPGRADE_FROM=$(echo "$file" | awk -F"_" '{print $2}')
    UPGRADE_TO=$(echo "$file" | awk -F"_" '{print $3}' | sed 's/\.sh//g')

    echo "Upgrading from $UPGRADE_FROM to $UPGRADE_TO ..."
    if [ "$UPGRADE_FROM" == "$CURRENT_MAJOR_VERSION.$CURRENT_MINOR_VERSION" ]; then
      $file
      CURRENT_MAJOR_VERSION=$(echo $UPGRADE_TO | awk -F"." '{print $1}')
      CURRENT_MINOR_VERSION=$(echo $UPGRADE_TO | awk -F"." '{print $2}')
    fi
  done
fi

echo "All done! Bye."
