#!/bin/bash -eux

function exec_usershell() {
	cd 
	exec sudo -u ${HOME} /bin/bash
}

# USER_ID=${LOCAL_UID:-9001}
# GROUP_ID=${LOCAL_GID:-9001}

# getent passwd ${LOCAL_WHOAMI} > /dev/null && exec_usershell

# echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
# useradd -u $USER_ID -o -m ${LOCAL_WHOAMI}
# groupmod -g $GROUP_ID ${LOCAL_WHOAMI}
# passwd -d ${LOCAL_WHOAMI}
# usermod -L ${LOCAL_WHOAMI}
# gpasswd -a ${LOCAL_WHOAMI} docker
# chown root:docker /var/run/docker.sock
# chmod 660 /var/run/docker.sock
# chown -R ${LOCAL_WHOAMI}:${LOCAL_WHOAMI} /etc/dotfiles
# echo "${LOCAL_WHOAMI} ALL=NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

# Quix 
mkdir -p ~/ros/workspaces/quix/src
cd ~/ros/workspaces/quix/src
catkin_init_workspace
git clone --recursive https://gitlab.com/team-quix/common/common_pkgs
git clone --recursive https://gitlab.com/team-quix/quince/quince_pkgs
git clone --recursive -b noetic-devel https://gitlab.com/team-quix/arm/arm_pkgs
git clone --recursive https://gitlab.com/team-quix/chassis/onix_chassis_pkgs

exec_usershell