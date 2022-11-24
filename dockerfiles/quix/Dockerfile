#############################################
# Created from template ros.dockerfile.jinja
#############################################

###########################################
# Base image 
###########################################
FROM ubuntu:20.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# Install language
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
	locales \
	&& locale-gen en_US.UTF-8 \
	&& update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
	&& rm -rf /var/lib/apt/lists/*
ENV LANG en_US.UTF-8

# Install timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	&& apt-get install -y tzdata \
	&& dpkg-reconfigure --frontend noninteractive tzdata \
	&& rm -rf /var/lib/apt/lists/*

# Install ROS
RUN apt-get update && apt-get install -y \
	curl \
	dirmngr \
	gnupg2 \
	lsb-release \
	sudo \
	&& sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
	&& curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
	&& apt-get update && apt-get install -y \
	ros-noetic-ros-base \
	&& rm -rf /var/lib/apt/lists/*

# Setup environment
ENV LD_LIBRARY_PATH=/opt/ros/noetic/lib
ENV ROS_DISTRO=noetic
ENV ROS_ROOT=/opt/ros/noetic/share/ros
ENV ROS_PACKAGE_PATH=/opt/ros/noetic/share
ENV ROS_MASTER_URI=http://localhost:11311
ENV ROS_PYTHON_VERSION=3
ENV ROS_VERSION=1
ENV PATH=/opt/ros/noetic/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ROSLISP_PACKAGE_DIRECTORIES=
ENV PYTHONPATH=/opt/ros/noetic/lib/python3/dist-packages
ENV PKG_CONFIG_PATH=/opt/ros/noetic/lib/pkgconfig
ENV ROS_ETC_DIR=/opt/ros/noetic/etc/ros
ENV CMAKE_PREFIX_PATH=/opt/ros/noetic
ENV DEBIAN_FRONTEND=

###########################################
# Develop image 
###########################################
FROM base AS dev

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list
# Install dev tools
# RUN apt-get update && apt-get install -y 
ARG USERNAME=quix
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG SSH_KEY

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
	&& useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
	# [Optional] Add sudo support for the non-root user
	&& apt-get update \
	&& apt-get install -y\
	sudo \
	git \
	openssh-server\
	&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
	&& chmod 0440 /etc/sudoers.d/$USERNAME 

# Cleanup & setup bashrc
RUN rm -rf /var/lib/apt/lists/* \
	&& echo "source /usr/share/bash-completion/completions/git" >> /home/$USERNAME/.bashrc \
	&& echo "if [ -f /opt/ros/${ROS_DISTRO}/setup.bash ]; then source /opt/ros/${ROS_DISTRO}/setup.bash; fi" >> /home/$USERNAME/.bashrc

USER $USERNAME
RUN mkdir -p /home/${USERNAME}/.ssh/
RUN echo $SSH_KEY > /home/${USERNAME}/.ssh/id_rsa  
# RUN ssh -o "StrictHostKeyChecking=no"
# RUN touch /home/${USERNAME}
RUN echo -e "Host gitlab.com\n\tStrictHostKeyChecking no\n" > /home/${USERNAME}/.ssh/config
# && sudo chmod -R 600 /home/${USERNAME}/.ssh/  
# RUN sudo ssh-keyscan -t rsa gitlab.com >> /home/${USERNAME}/.ssh/known_hosts

RUN mkdir -p /home/quix/ros/workspaces/quix/src \
	&& cd /home/quix/ros/workspaces/quix/src 
# RUN sudo git clone --recursive git@gitlab.com:team-quix/common/common_pkgs.git 
#&& git clone --recursive git@gitlab.com:team-quix/quince/quince_pkgs.git \
#&& git clone --recursive -b noetic-devel git@gitlab.com:team-quix/arm/arm_pkgs.git \
#&& git clone --recursive git@gitlab.com:team-quix/chassis/onix_chassis_pkgs.git
ENV DEBIAN_FRONTEND=

###########################################
# Full image 
###########################################
FROM dev AS full

ENV DEBIAN_FRONTEND=noninteractive
RUN sudo sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list
# Install the full release
RUN sudo apt-get update && sudo apt-get install -y --fix-missing\
	ros-$ROS_DISTRO-ros-controllers\ 
	ros-$ROS_DISTRO-joint-trajectory-controller\ 
	ros-$ROS_DISTRO-transmission-interface\ 
	ros-$ROS_DISTRO-trac-ik\
	ros-$ROS_DISTRO-moveit\ 
	ros-$ROS_DISTRO-joy\ 
	ros-$ROS_DISTRO-trajectory-msgs\ 
	ros-$ROS_DISTRO-navigation\
	ros-$ROS_DISTRO-tf2-sensor-msgs\ 
	ros-$ROS_DISTRO-neonavigation-msgs\ 
	python3-pyassimp\ 
	libzbar-dev\ 
	libx264-dev\ 
	gstreamer1.0-plugins-base\ 
	gstreamer1.0-tools\ 
	libgstreamer1.0-dev\ 
	libgstreamer-plugins-base1.0-dev\
	libpcap-dev\
	x11-apps \
	python3-rosdep \
	python3-rosinstall \
	python3-rosinstall-generator \
	python3-wstool \
	python3-pip \
	python3-pep8 \
	python3-autopep8 \
	pylint3 \
	build-essential \
	bash-completion \
	git \
	vim \
	byobu \
	openssh-server \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm /etc/apt/apt.conf.d/docker-clean \
	&& rosdep init || echo "rosdep already initialized" 

ENV DEBIAN_FRONTEND=
#ros-noetic-desktop \
#ros-noetic-rviz \
# COPY entrypoint.sh /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["bash"]

###########################################
#  Full+Gazebo image 
###########################################
# FROM full AS gazebo

# ENV DEBIAN_FRONTEND=noninteractive
# # Install gazebo
# RUN apt-get update && apt-get install -y \
# 	ros-noetic-gazebo* \
# 	&& rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=

# ###########################################
# #  Full+Gazebo+Nvidia image 
# ###########################################

# FROM gazebo AS gazebo-nvidia

# ################
# # Expose the nvidia driver to allow opengl 
# # Dependencies for glvnd and X11.
# ################
# RUN apt-get update \
# 	&& apt-get install -y -qq --no-install-recommends \
# 	libglvnd0 \
# 	libgl1 \
# 	libglx0 \
# 	libegl1 \
# 	libxext6 \
# 	libx11-6

# # Env vars for the nvidia-container-runtime.
# ENV NVIDIA_VISIBLE_DEVICES all
# ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
# ENV QT_X11_NO_MITSHM 1