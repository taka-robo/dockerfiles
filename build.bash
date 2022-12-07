#!/bin/bash -eux
# PRIVATE_KEY=$(sudo cat ~/.ssh/id_rsa)
# ./dockerfiles/quix/install_script.bash
docker image build --build-arg local_docker_gid=999 -t taka/quix dockerfiles/quix/.
sleep 1 
docker run --name quix --net=host --privileged -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it -e LOCAL_UID=1000 -e LOCAL_GID=1000 -e LOCAL_HOME=/home/taka -e LOCAL_WHOAMI=taka -e LOCAL_HOSTNAME=taka-lab --mount type=bind,src=/home/taka/.ssh,dst=/home/taka/.ssh,ro --mount type=bind,src=/home/taka/.ssh/known_hosts,dst=/home/taka/.ssh/known_hosts --rm    taka/quix /bin/bash
