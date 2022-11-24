#!/bin/bash

function exec_usershell(){
		cd "${LOCAL_HOME}"
		exec sudo -u ${LOCAL_WHOAMI} /bin/bash
}
USER_ID=${LOCAL_UID:-9001}
GROUP_ID=${LOCAL_GID:-9001}

echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
# useradd -u $USER_ID -o -m ${LOCAL_WHOAMI}
# groupmod -g $GROUP_ID ${LOCAL_WHOAMI}
# export HOME=/home/${LOCAL_WHOAMI}

useradd -u $USER_ID -o -m user
groupmod -g $GROUP_ID user
export HOME=/home/user
cd user
# exec /usr/sbin/gosu ${LOCAL_WHOAMI} "$@"
exec /usr/sbin/gosu user "$@"
# exec_usershell