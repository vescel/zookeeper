# vescel/zookeeper: dockerized kafka for Joyent Triton
vescel/zookeeper is a dockerized [apache zookeeper](https://zookeeper.apache.org//) installation for the [Joyent Triton Containers as a Service](https://www.joyent.com/triton) platform that makes use of [Joyent's ContainerPilot](https://www.joyent.com/containerpilot) for container scheduling.

the vescel/zookeeper container has an automated builds available on [dockerhub](https://hub.docker.com/r/vescel)

for detail usage (including kafka and kafka-manager) visit https://github.com/vescel/platform

## How-to
### local machine prerequsites
#### Mac OSX
[docker toolbox](https://www.docker.com/products/docker-toolbox) must be installed. Docker for Mac is still fresh, and I haven't had a chance to work out the network bugs yet, so stick with docker toolbox for now.

### Mac OSX Quick Start
ContainerPilot assumes a dockerized [hashicorp consul](https://www.consul.io/) be running. I use [progrium/consul](https://hub.docker.com/r/progrium/consul/) using the following command:

```
docker run -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1 progrium/consul -server -bootstrap -ui-dir /ui
```
this command will launch a single consul instance (sufficient for development) that will have the consul UI available on port 8500 of the local machine at: 

```
docker-machine ip default
```

Clone this repository to your local machine. cd into vescel/kafka and run the following command to create the required ENV file

```
./env.sh local
```

confirm that a file with name _env exists in the local directory, then run:

```
docker-compose up
```
this will create a single instance of zookeeper, available on port 2181.

Scaling to a multiple node installation is accomplished with the following command:

```
docker-compose scale zookeeper=3
