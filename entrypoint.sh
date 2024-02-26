#! /bin/bash

UBUNTU_USER_UID=1000
UBUNTU_USER_GID=1000
USER_HOME=/home/app

if [ -z "$HOST_UID" ] || [ -z "$HOST_GID" ]; then
    echo "HOST_UID and HOST_GID must be set"
    exit 1
fi

# If $HOST_UID and $HOST_GID is less than 1000, force to 1000
# Because the user with UID less than 1000 is a system user
if [ $HOST_UID -lt $UBUNTU_USER_UID ]; then
    HOST_UID=$UBUNTU_USER_UID
fi
if [ $HOST_GID -lt $UBUNTU_USER_GID ]; then
    HOST_GID=$UBUNTU_USER_GID
fi

echo "Changing UID and GID of app to $HOST_UID and $HOST_GID"
usermod -u $HOST_UID app
groupmod -g $HOST_GID app

chown $HOST_UID:$HOST_GID /app/
chmod 0755 /app/

exec gosu app "$@"