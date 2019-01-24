
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

FROM tomcat:9-jre8

MAINTAINER  Gabriel Fedel

# User root is required to install all needed packages
USER root

ENV APPLIANCE_NAME epics-archiver-appliances
ENV APPLIANCE_FOLDER /opt/${APPLIANCE_NAME}

RUN mkdir -p ${APPLIANCE_FOLDER}/build/scripts

# General EPICS Archiver Appliance Setup
ENV ARCHAPPL_SITEID lnls-sol-archiver

# Used packages
RUN apt-get update
RUN apt-get install -y git libreadline7 libtinfo-dev readline-common openjdk-8-jdk perl tar xmlstarlet wget ant

# Install EPICS base
RUN apt-get update
RUN apt-get install wget make gcc g++ perl-modules-5.24 libreadline-dev -y

WORKDIR /tmp
COPY install.sh ./
RUN chmod +x install.sh
RUN ./install.sh

COPY epics.sh /etc/profile.d/
RUN chmod +x /etc/profile.d/epics.sh
RUN echo ". /etc/profile.d/epics.sh" >> /etc/bash.bashrc

#RUN rm epics.sh
RUN rm install.sh


# Github repository variables
ENV GITHUB_REPOSITORY_FOLDER /opt/epicsarchiverap
#ENV GITHUB_REPOSITORY_URL https://github.com/lnls-sol/epicsarchiverap

# Clone archiver github's repository
#RUN git clone ${GITHUB_REPOSITORY_URL} ${GITHUB_REPOSITORY_FOLDER}

#this is temporary. It is more fast then use git clone
COPY epicsarchiverap ${GITHUB_REPOSITORY_FOLDER}

# add configuration files 
RUN mkdir -p ${GITHUB_REPOSITORY_FOLDER}/src/sitespecific/${ARCHAPPL_SITEID}/classpathfiles
RUN cp ${GITHUB_REPOSITORY_FOLDER}/src/sitespecific/slacdev/classpathfiles/archappl.properties  ${GITHUB_REPOSITORY_FOLDER}/src/sitespecific/${ARCHAPPL_SITEID}/classpathfiles

COPY lnls_appliances.xml ${GITHUB_REPOSITORY_FOLDER}/src/sitespecific/${ARCHAPPL_SITEID}/classpathfiles/appliances.xml

COPY lnls_policies.py ${GITHUB_REPOSITORY_FOLDER}/src/sitespecific/${ARCHAPPL_SITEID}/classpathfiles/policies.py

RUN mkdir -p ${APPLIANCE_FOLDER}/build/bin

### Set up mysql connector
ENV MYSQL_CONNECTOR mysql-connector-java-8.0.14

RUN wget -P ${APPLIANCE_FOLDER}/build/bin https://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_CONNECTOR}.tar.gz

RUN tar -C ${APPLIANCE_FOLDER}/build/bin -xvf ${APPLIANCE_FOLDER}/build/bin/${MYSQL_CONNECTOR}.tar.gz

RUN cp ${APPLIANCE_FOLDER}/build/bin/${MYSQL_CONNECTOR}/${MYSQL_CONNECTOR}.jar ${CATALINA_HOME}/lib

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

# clean
RUN rm -rf /var/lib/apt/lists/*

