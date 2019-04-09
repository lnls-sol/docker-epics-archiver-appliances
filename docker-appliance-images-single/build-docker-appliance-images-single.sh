#!/bin/bash

#
# A simple bash script to build four different Docker images: one for each EPICS Archiver Appliance
#
# Gabriel Fedel 
# Beamlines Control Group - Brazilian Synchrotron Light Source Laboratory - LNLS
# Gustavo Ciotto Pinton
# LNLS - Brazilian Synchrotron Light Source
# Controls Group
#

. ./env-vars-single.sh

### Build STS, MTS and LTS volumes

DOCKER_STS_CONTAINER=$(docker ps -a | grep ${SHORT_TERM_VOLUME_NAME})

if [ -z ${DOCKER_STS_CONTAINER:+x} ]; then
    echo "${SHORT_TERM_VOLUME_FOLDER} has not been created. Creating... "
    docker create -v ${SHORT_TERM_VOLUME_FOLDER} --name ${SHORT_TERM_VOLUME_NAME} debian &> /dev/null
fi

DOCKER_MTS_CONTAINER=$(docker ps -a | grep ${MEDIUM_TERM_VOLUME_NAME})
if [ -z ${DOCKER_MTS_CONTAINER:+x} ]; then   
    echo "${MEDIUM_TERM_VOLUME_FOLDER} has not been created. Creating... "
    docker create -v ${MEDIUM_TERM_VOLUME_FOLDER} --name ${MEDIUM_TERM_VOLUME_NAME} debian &> /dev/null
fi

DOCKER_LTS_CONTAINER=$(docker ps -a | grep ${LONG_TERM_VOLUME_NAME})
if [ -z ${DOCKER_LTS_CONTAINER:+x} ]; then
    echo "${LONG_TERM_VOLUME_FOLDER} has not been created. Creating... "
    docker create -v ${LONG_TERM_VOLUME_FOLDER} --name ${LONG_TERM_VOLUME_NAME} debian &> /dev/null
fi


set -x
docker build -t ${DOCKER_MANTAINER_NAME}/${DOCKER_NAME}:${DOCKER_TAG} .

