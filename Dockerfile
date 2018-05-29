#
# Docker image for a general EPICS Archiver Appliance. It consists of 
# the base image for the mgmt, etl, engine and retrieval Docker containers.
# 
# Gabriel Fedel 
# Beamlines Control Group - Brazilian Synchrotron Light Source Laboratory - LNLS
# Gustavo Ciotto Pinton
# LNLS - Brazilian Synchrotron Light Source
# Controls Group
#
#

FROM tomcat:9

MAINTAINER  Gabriel Fedel

# User root is required to install all needed packages
USER root

ENV APPLIANCE_NAME epics-archiver-appliances
ENV APPLIANCE_FOLDER /opt/${APPLIANCE_NAME}

RUN mkdir -p ${APPLIANCE_FOLDER}/build/scripts

# General EPICS Archiver Appliance Setup
ENV ARCHAPPL_SITEID lnls-sol-archiver

# Install EPICS base
RUN apt-get update && apt-get install -y git libreadline7 libreadline-dev libtinfo-dev readline-common openjdk-8-jdk perl tar xmlstarlet wget ant && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/lnls-sol/epics-base_debs
# ignore epics-perl (this package have some problems)
RUN rm epics-base_debs/debs/epics-perl_3.15.3-13_amd64.deb
RUN dpkg -i epics-base_debs/debs/*.deb
RUN rm -rf epics-base_debs
RUN mkdir /usr/local/epics
RUN ln -s /usr/lib/epics /usr/local/epics/base

# Github repository variables
ENV GITHUB_REPOSITORY_FOLDER /opt/epicsarchiverap
ENV GITHUB_REPOSITORY_URL https://github.com/slacmshankar/epicsarchiverap

# Clone archiver github's repository
RUN git clone ${GITHUB_REPOSITORY_URL} ${GITHUB_REPOSITORY_FOLDER}

RUN mkdir -p ${APPLIANCE_FOLDER}/build/bin

### Set up mysql connector
ENV MYSQL_CONNECTOR mysql-connector-java-5.1.41

RUN wget -P ${APPLIANCE_FOLDER}/build/bin https://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_CONNECTOR}.tar.gz

RUN tar -C ${APPLIANCE_FOLDER}/build/bin -xvf ${APPLIANCE_FOLDER}/build/bin/${MYSQL_CONNECTOR}.tar.gz

RUN cp ${APPLIANCE_FOLDER}/build/bin/${MYSQL_CONNECTOR}/${MYSQL_CONNECTOR}-bin.jar ${CATALINA_HOME}/lib

RUN rm -R ${APPLIANCE_FOLDER}/build/bin/${MYSQL_CONNECTOR}/

RUN mkdir -p ${APPLIANCE_FOLDER}/configuration

RUN mkdir -p ${APPLIANCE_FOLDER}/storage

# ARCHAPPL_APPLIANCES is always the same for every image, but ARCHAPPL_MYIDENTITY is not. So it needs to be 
# defined when the container is started
ENV ARCHAPPL_APPLIANCES ${APPLIANCE_FOLDER}/configuration/lnls_appliances.xml
ENV ARCHAPPL_POLICIES ${APPLIANCE_FOLDER}/configuration/lnls_policies.py
ENV ARCHAPPL_SHORT_TERM_FOLDER ${APPLIANCE_FOLDER}/storage/sts
ENV ARCHAPPL_MEDIUM_TERM_FOLDER ${APPLIANCE_FOLDER}/storage/mts
ENV ARCHAPPL_LONG_TERM_FOLDER ${APPLIANCE_FOLDER}/storage/lts

RUN mkdir -p ${ARCHAPPL_SHORT_TERM_FOLDER}
RUN mkdir -p ${ARCHAPPL_MEDIUM_TERM_FOLDER}
RUN mkdir -p ${ARCHAPPL_LONG_TERM_FOLDER}

RUN mkdir -p ${APPLIANCE_FOLDER}/build/configuration/wait-for-it
RUN git clone https://github.com/vishnubob/wait-for-it.git ${APPLIANCE_FOLDER}/build/configuration/wait-for-it


