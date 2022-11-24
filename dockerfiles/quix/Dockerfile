#############################################
# Created from template ros.dockerfile.jinja
#############################################

###########################################
# Base image 
###########################################
FROM ubuntu:20.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# Install language
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
# Install dev tools
RUN apt-get update && apt-get install -y \
	x11-apps \
	python3-rosdep \
	python3-rosinstall \
	python3-rosinstall-generator \
	python3-wstool \
	python3-pip \
	python3-pep8 \
	python3-autopep8 \
	python3-pyassim\
	pylint3 \
	build-essential \
	bash-completion \
	git \
	vim \
	libzbar-dev\
	libx264-dev\
	byobu\
	gstreamer1.0-plugins-base \
	gstreamer1.0-tools\
	libgstreamer1.0-dev\ 
	libgstreamer-plugins-base1.0-dev\
	libpcap-dev\
	ros-${ROS_DISTRO}-navigation\
	ros-${ROS_DISTRO}-tf2-sensor-msgs \
	ros-${ROS_DISTRO}-neonavigation-msgs \
	ros-${ROS_DISTRO}-ros-controllers \
	ros-${ROS_DISTRO}-joint-trajectory-controller\ 
	ros-${ROS_DISTRO}-transmission-interface \
	ros-${ROS_DISTRO}-trac-ik\
	ros-${ROS_DISTRO}-moveit\ 
	ros-${ROS_DISTRO}-joy \
	ros-${ROS_DISTRO}-trajectory-msgs \
	&& rm -rf /var/lib/apt/lists/* \
	&& rosdep init || echo "rosdep already initialized"


ENV DEBIAN_FRONTEND=

###########################################
# Full image 
###########################################
FROM dev AS full

ENV DEBIAN_FRONTEND=noninteractive
# Install the full release
RUN apt-get update && apt-get install -y --fix-missing\
	ros-noetic-desktop \
	&& rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=

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