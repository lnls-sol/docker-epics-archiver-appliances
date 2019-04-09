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

if [ ! -d "/opt/epics-archiver-appliances" ]; then
    mkdir -p /opt/epics-archiver-appliances/configuration
    mkdir -p /opt/epics-archiver-appliances/storage/sts
    mkdir /opt/epics-archiver-appliances/storage/mts
    mkdir /opt/epics-archiver-appliances/storage/lts
    cp lnls* /opt/epics-archiver-appliances/configuration
fi

docker build -t ${DOCKER_MANTAINER_NAME}/${DOCKER_NAME}:${DOCKER_TAG} .
