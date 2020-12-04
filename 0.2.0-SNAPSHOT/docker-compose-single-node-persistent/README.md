# docker-compose-single-node

Simple deployment on a single node using docker-compose with persistent data storage. 

This basic example shows how the data of the two main databases (MongoDB and InfluxDB) can be saved to the host's file system using docker volumes and thus all
containers can be getting recreated without data loss. Still a production system should at least add a backup strategy to ensure that the data gets not lost 
even if the node's hard disk fails.

There is only one single instance of the cloud.iO application started which includes all services as one Spring Boot application. This simplifies deployment 
and is perfectly fine for a single node deployment but it might not be well adapted to handle high loads and is not optimal for scalability as all services get
multiplied and not the ones that are under heavy load.

## Requirements

- **make**:  
  Used to automate key, certificate and keystore/truststore creation.
- **OpenSSL**:  
  Needed to create keys, certificates and keystores/truststores. Another use is the creation of a random password for the admin user.
- **Docker**:
  As all services are deployed as Docker containers, obviously Docker is required.
- **docker-compose**
  The `docker-compose` is bundled with the Docker installer on some platforms, for those where this is not the case, `docker-compose` has to be installed.
- **Java keytool**
  The keytool utility from the JDK is required. We propose to install `openjdk-11-jre-headless` which is quite small for a Java installation.
  
## How to run

Two scripts are present in order to create and start, or stop and destroy all services.

Should you not be able to run any of the `*.sh` commands, you need to make the scripts executable:

    # chmod +x *.sh

Using the command `./up.sh` you can create and start the required Docker containers. The `up.sh` script does the following steps:

- Create all needed cryptographic keys, certificates and keystores/truststores.
- Create a random password for the admin user on services that require authentication.
- Exports the required certificates and keys as environment variables.
- Pulls the latest version of the docker images.
- Starts the application stack using docker-compose.

The command `stop.sh` stops (pauses) a running cloud.iO application stack without destroying the containers and their data.

Using the command `start.sh` an cloud.iO application stack in a stopped state can be resumed.

The command `down.sh` stops and removes all containers of the cloud.iO application stack, but all all data stored in MongoDB and InfluxDB will remain intact 
along with the keys, certificates and keystores/truststores.

The typical use of this command is to force recreation of all containers.

## Files and folders

- `certificates`:  
This folder will contain all  keys, certificates and keystores for the CA, the message broker and the services after the Makefile was processed.  
The folder initiall contains just 2 files: 
  - `openssl.cnf`:  
    OpenSSL configuration used to generate the keys, certificates and keystores.
  - `Makefile`:  
    Makefile that automates the creation of all required keys, certificates and keystores.  
- `docker-compose.yml`:  
  Contains the service definition of the cloud.iO application stack. Due to the limitations of the syntax for evironment variables, those are defined in bash 
  scripts.
- `up.sh`:  
  Creates the network, the containers, the links between them and starts all containers in background. This command can be used too to update running 
  containers.
- `stop.sh`:  
  Stops the running containers of the cloud.iO application stack without actually removing them.
- `start.sh`:
  Resumes a cloud.iO application stack that was stopped using the command `stop.sh` before.
- `down.sh`:  
  Stops and removes all containers and removes the docker network. All data in MongoDB and InfluxDB along with the passwords, keys, certificates and 
  keystores/trusstores will be preserved.
