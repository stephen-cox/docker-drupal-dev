#!/bin/bash

# Declare db module
MODULES[docker]='Docker functions'

# Declare db module commands
declare -A docker_COMMANDS
docker_COMMANDS[destroy]='Delete all docker containers and images'
docker_COMMANDS[vclean]='Clean up unused volumes'


##
# Remove all containers and volumes
##
function docker_destroy() {
    echo "Deleting all containers and volumes"
    confirm "You are about to delete all your docker containers and volumes"

    echo "Deleting all containers"
    docker rm $(docker ps -a -q)
    echo "Deleting all images"
    docker rmi $(docker images -q)
}

##
# Remove all unused volumes
##
function docker_vclean() {
    echo "Cleaning up unused volumes"

    docker volume ls -qf dangling=true | xargs -r docker volume rm
}
