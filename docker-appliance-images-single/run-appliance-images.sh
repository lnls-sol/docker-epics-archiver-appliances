#!/bin/bash

. ./env-vars-single.sh


CONTAINERS=$(docker ps -a | grep ${DOCKER_RUN_NAME})

    if [ ! -z "$CONTAINERS" ]; then
        docker stop ${DOCKER_RUN_NAME}
        docker rm ${DOCKER_RUN_NAME}
    fi

    APPLIANCE_PORT_MGMT=11995
    APPLIANCE_PORT_RET=11998
    docker run -d --name=${DOCKER_RUN_NAME} --dns=10.0.0.71 --dns=10.0.0.72 \
        -p ${APPLIANCE_PORT_MGMT}:${APPLIANCE_PORT_MGMT} -p ${APPLIANCE_PORT_RET}:${APPLIANCE_PORT_RET} --network=${NETWORK_ID} \
        --volumes-from=${SHORT_TERM_VOLUME_NAME} --volumes-from=${MEDIUM_TERM_VOLUME_NAME} --volumes-from=${LONG_TERM_VOLUME_NAME} \
        -v /opt/epics-archiver-appliances/configuration/:/opt/epics-archiver-appliances/configuration/ \
    --env-file lnls-epics-archiver.env  ${DOCKER_MANTAINER_NAME}/${DOCKER_NAME}:${DOCKER_TAG}
