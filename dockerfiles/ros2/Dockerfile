# docker build -t ros2:${ROS_DISTORO} .
# docker run --rm -it --privileged -u ros --net=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix ros2:${ROS_DISTORO}
##############################################
# Created from template ros2.dockerfile.jinja
##############################################

###########################################
# Base image 
###########################################
ARG ROS_DISTRO=foxy

FROM ubuntu:20.04 AS base

ARG ROS_DISTRO
ENV DEBIAN_FRONTEND=noninteractive
ENV AMENT_PREFIX_PATH=/opt/ros/$ROS_DISTRO
ENV COLCON_PREFIX_PATH=/opt/ros/$ROS_DISTRO
ENV LD_LIBRARY_PATH=/opt/ros/$ROS_DISTRO/lib
ENV PATH=/opt/ros/$ROS_DISTRO/bin:$PATH
ENV PYTHONPATH=/opt/ros/$ROS_DISTRO/lib/python3.8/site-packages
ENV ROS_PYTHON_VERSION=3
ENV ROS_VERSION=2

# Install language
RUN apt-get update && apt-get install -y \
	locales apt-utils\
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

# Install ROS2
RUN apt-get update && apt-get install -y \
	curl \
	gnupg2 \
	lsb-release \
	sudo \
	&& curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
	&& apt-get update && apt-get install -y \
	ros-${ROS_DISTRO}-ros-base \
	python3-argcomplete \
	&& rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=

###########################################
#  Develop image 
###########################################
FROM base AS dev

ENV DEBIAN_FRONTEND=noninteractive
ARG ROS_DISTRO
RUN apt-get update && apt-get install -y \
	bash-completion \
	build-essential \
	iputils-ping \
	net-tools \
	cmake \
	gdb \
	git \
	pylint3 \
	byobu\
	x11-apps\
	python3-argcomplete \
	python3-colcon-common-extensions \
	python3-pip \
	python3-rosdep \
	python3-vcstool \
	vim \
	wget \
	# Install ros distro testing packages
	ros-${ROS_DISTRO}-ament-lint \
	ros-${ROS_DISTRO}-launch-testing \
	ros-${ROS_DISTRO}-launch-testing-ament-cmake \
	ros-${ROS_DISTRO}-launch-testing-ros \
	python3-autopep8 \
	&& rm -rf /var/lib/apt/lists/* \
	&& rosdep init || echo "rosdep already initialized"


ENV DEBIAN_FRONTEND=

###########################################
#  Full image 
###########################################
FROM dev AS full

ENV DEBIAN_FRONTEND=noninteractive
ARG ROS_DISTRO

# Install the full release
RUN sudo apt-get update && sudo apt-get install -y \
	ros-${ROS_DISTRO}-desktop \
	libgl1-mesa-glx libgl1-mesa-dri \
	&& rosdep update \
	&& sudo rm -rf /var/lib/apt/lists/*
COPY ros_entrypoint.sh /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
ENV DEBIAN_FRONTEND=

###########################################
#  Full+Gazebo image 
###########################################
# FROM full AS gazebo

# ENV DEBIAN_FRONTEND=noninteractive
# ARG ROS_DISTRO=foxy
# # Install gazebo
# RUN apt-get update && apt-get install -y \
# 	ros-${ROS_DISTORO}-gazebo* \
# 	&& rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=

###########################################
#  Full+Gazebo+Nvidia image 
###########################################

# FROM gazebo AS gazebo-nvidia

# ################
# # Expose the nvidia driver to allow opengl 
# # Dependencies for glvnd and X11.
# ARG ROS_DISTRO=foxy
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