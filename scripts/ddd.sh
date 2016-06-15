#!/bin/bash

echo -e "Docker Drupal Development helper script\n"

##
# Print help
##
function help() {

    echo -e "Usage:
    ddd [module] [command]"

    for I in "${!MODULES[@]}"; do
        echo -e "\nModule: ${I} - ${MODULES[${I}]}"
        declare -n COMMANDS="${I}_COMMANDS"
        echo "Commands:"
        for J in "${!COMMANDS[@]}"; do
            echo "$J - ${COMMANDS[${J}]}"
        done
    done
}

##
# Confirm operation before continuing
# PARAM Message to display
##
function confirm() {
    MESSAGE=$1

    if [ "$1" != "-y" ]; then
        echo "Warning: ${MESSAGE}"
        read -n 1 -p "Are you sure [Y/N]? " REPLY
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted"
            exit 1
        fi
    fi
}

# Initialise metadata and load commands
declare -A MODULES
THIS=$(readlink -f "${BASH_SOURCE[0]}")
CWD=$(dirname "${THIS}")
for F in ${CWD}/commands/*.sh; do
    source $F
done

# Parse commandline arguments
if [ "$1" = "help" ]; then
    help
    exit 0
elif [ $# -eq 2 ]; then
    MODULE=$1
    COMMAND=$2
else
    help
    exit 1
fi

# Check module exist
if [[ ! ${MODULES[$MODULE]} ]]; then
    echo "Error: Module ${MODULE} is not defined"
    exit 1
fi

# Check command exists
declare -n COMMANDS="${MODULE}_COMMANDS"
if [[ ! ${COMMANDS[$COMMAND]} ]]; then
    echo "Error: Command ${COMMAND} is not defined in module ${MODULE}"
    exit 1
fi

# Execute function
${MODULE}_${COMMAND}
