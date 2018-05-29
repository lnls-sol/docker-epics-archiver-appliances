#!/bin/sh

#
# A simple script to build a base image for the appliance containers.
#
# Gabriel Fedel 
# Beamlines Control Group - Brazilian Synchrotron Light Source Laboratory - LNLS
# Gustavo Ciotto Pinton
# Controls Group - Brazilian Synchrotron Light Source Laboratory - LNLS
#

. ./env-vars.sh

docker build -t ${DOCKER_MANTAINER_NAME}/${DOCKER_NAME}:${DOCKER_TAG} .
