# Setuping a archiver:

* clone docker repositories:

```
git clone https://github.com/lnls-sol/docker-epics-archiver-appliances
git clone https://github.com/lnls-sol/docker-epics-archiver-db
```

* change both repositorires to branch dev

* clone epics archiver ap repository (this is a temporary step, the best 
solution make clone in build process):
```
cd docker-epics-archiver-appliances
git clone https://github.com/slacmshankar/epicsarchiverap
```

* Create configuration files

    * create /opt/epics-archiver-appliances/configuration
    * copy configuration files :
```
cp docker-epics-archiver-appliances/lnls_appliances.xml /opt/epics-archiver-appliances/configuration/
cp docker-epics-archiver-appliances/lnls_policies.py /opt/epics-archiver-appliances/configuration/

```

* build and start mysql-appliance (when build, it will creates volume and network)
```
docker-epics-archiver-db/build-docker-archiver-db.sh
docker-epics-archiver-db/run-docker-archiver-db.sh
```

* build docker-generic appliance

```
docker-epics-archiver-appliances/build-docker-generic-appliance.sh
```

* build and start docker-appliance-images-single:

```
docker-epics-archiver-appliances/docker-appliance-images-single/build-docker-appliance-images-single.sh
docker-epics-archiver-appliances/docker-appliance-images-single/run-appliance-images.sh
```

# TODO

* undertand volume
* work with separeted dockers (?)
