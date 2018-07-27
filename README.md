# Archiver


## Local Docker Swarm

https://docs.docker.com/engine/swarm/stack-deploy/

```shell
$ docker service create --name registry --publish published=5000,target=5000 registry:2

$ docker-compose -f swarm.yml push

$ docker stack deploy --compose-file swarm.yml archiver

```

- Visit http://localhost:5002 for UI.
- Visit http://localhost:9090 for Docker Visualizer.

