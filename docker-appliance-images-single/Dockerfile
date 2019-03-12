#
# Docker image for mgmt, retrieval, etl and engine servlets. It receives two
# arguments: the first is the name of the appliance this image will belong to and
# the second is the name of the appliance (mgmt, retrieval, etl or engine).
# 
# Gabriel Fedel 
# Beamlines Control Group - Brazilian Synchrotron Light Source Laboratory - LNLS
# Gustavo Ciotto Pinton
# LNLS - Brazilian Synchrotron Light Source
# Controls Group
#

FROM lnlssol/epics-archiver-generic:latest

MAINTAINER Gabriel Fedel

# user root is required to install all needed packages
USER root

RUN apt-get update && apt-get install vim -y

ENV APPLIANCE_NAME epics-archiver-appliances

ENV APPLIANCE_FOLDER /opt/${APPLIANCE_NAME}

RUN mkdir -p ${APPLIANCE_FOLDER}/all

COPY setup-appliance.sh \
     tomcat-service.sh \
     ${APPLIANCE_FOLDER}/build/scripts/

COPY configuration/context.xml \
     ${CATALINA_HOME}/conf/context.xml

RUN mkdir ${APPLIANCE_FOLDER}/build/cert/

# configure apache as a proxy and point to archiver appliance
RUN apt install apache2 -y
RUN a2enmod proxy
RUN a2enmod proxy_http
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

CMD ["sh", "-c", "${APPLIANCE_FOLDER}/build/scripts/tomcat-service.sh"]
