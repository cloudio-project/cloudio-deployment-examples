# docker-compose-single-node

Simple deployment on a single node using docker-compose. 

Note that this is a very basic example that is not meant for a production systems because it does not mount data volumes in order to preserve the data if the 
services are destroyed or updated nor are there any backup procedures foreseen. In the case a container gets updated or destroyed, all data is most probably 
lost. However it is simple enough to get started quickly or can serve as a  starting point for a deployment.

There is only one single instance of the cloud.iO application started which includes all services as one Spring Boot application. This simplifies deployment 
and is perfectly fine for a single node deployment but it might not be well adapted to handle high loads and is not scalable as it is.

## Requirements

- **make**:  
  Used to automate key, certificate and keystore/truststore creation.
- **OpenSSL**:  
  Needed to create keys, certificates and keystores/truststores. Another use is the creation of a random password for the admin user.
- **Docker**:
  As all services are deployed as Docker containers, obviously Docker is required.
- **docker-compose**
  The `docker-compose` is bundled with the Docker installer on some platforms, for those where this is not the case, `docker-compose` has to be installed.

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

The command `down.sh` stops and deletes all containers of the cloud.iO application stack and deletes all keys, certificates and keystores/truststores. 

> **Use with caution!**  
> The command `down.sh` will delete **all data** including users, history data, access rights, encpoint configuration, keys and certificates. This means that 
> Endpoints configured for this node will not be able to connect anymore.

The typical use of this command would be to cleanup everything after a test run.

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
  containers, but note that all data of the containers that are updated are lost.
- `stop.sh`:  
  Stops the running containers of the cloud.iO application stack without removing them, so all data is preserved as long the containers get not updated or 
  destroyed by another command.
- `start.sh`:
  Resumes a cloud.iO application stack that was stopped using the command `stop.sh` before.
- `down.sh`:  
  Stops and destroys all containers, removes the docker network and deletes all passwords, keys, certificates and keystores/trusstores.
