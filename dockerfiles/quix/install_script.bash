#!/bin/bash -eux

cd "$(dirname "$0")"
mkdir -p ./clone_ws
cd clone_ws
git clone --recursive https://gitlab.com/team-quix/common/common_pkgs
git clone --recursive https://gitlab.com/team-quix/quince/quince_pkgs
git clone -b noetic-devel --recursive https://gitlab.com/team-quix/arm/arm_pkgs
git clone --recursive https://gitlab.com/team-quix/chassis/onix_chassis_pkgs
