
# docker build -t qt5 .
# docker run --rm -it --privileged -u ubuntu --net=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix qt5
FROM ubuntu:20.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list


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
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
	curl \
	gnupg2 \
	lsb-release \
	sudo \
	&& apt-get clean

###########################################
#  Develop image 
###########################################
FROM base AS dev

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
	software-properties-common \
	bash-completion \
	build-essential \
	cmake \
	gdb \
	git \
	pylint3 \
	byobu\
	x11-apps\
	vim \
	wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* 

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
	&& useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
	# [Optional] Add sudo support for the non-root user
	&& apt-get update \
	&& apt-get install -y sudo \
	&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
	&& chmod 0440 /etc/sudoers.d/$USERNAME \
	# Cleanup
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& echo "source /usr/share/bash-completion/completions/git" >> /home/$USERNAME/.bashrc 

ENV DEBIAN_FRONTEND=

###########################################
#  Full image 
###########################################
FROM dev AS qt

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

# Install the full release
RUN sudo add-apt-repository ppa:beineri/opt-qt-5.15.2-focal \
	&& sudo apt-get update && sudo apt upgrade -y \
	&& sudo apt-get install -y \
	cmake gcc g++ libeigen3-dev libboost1.71-dev libqt5serialport5-dev qt515serialport qt515base libprotobuf-dev libprotoc-dev protobuf-compiler ninja-build libgtest-dev \
	libgl1-mesa-glx libgl1-mesa-dri \
	&& sudo apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=