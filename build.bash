#!/bin/bash -eux
PRIVATE_KEY=$(sudo cat ~/.ssh/id_rsa)
docker image build --build-arg local_docker_gid=999 --build-arg SSH_KEY="$PRIVATE_KEY" -t taka/quix dockerfiles/quix/.