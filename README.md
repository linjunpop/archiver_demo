# Archiver

A demo application to imitate the RingCentral Archiver.

## Description

It's an Elixir Umbrella application, which include these sub-applications:

- `archiver_fetcher` - fetch recordings from the Platform API.
- `archiver_dropbox` - Deliver data to Dropbox with a http pooling.
- `archiver_google_drive` - Deliver data to Google Drive with a per-user worker system.
- `archiver_shared` - Common lib for other applications.
- `archiver_ui` - The Web UI

```
+-------------------------------------------------------------------------------+
|                                     Archiver                                  |
|                                                                               |
|  +--------+            +---------------+          +-------------------------+ |
|  |        |            |               |          |         Worker          | |
|  |   UI   |            |    Fetcher    |          |                         | |
|  |        |            |               |          | +--------+ +----------+ | |
|  |        |   HTTP     |               |   HTTP   | |        | |          | | |
|  |        +----------->|               |<---------+ | Google | | Dropbox  | | |
|  |        |            |               |          | | Drive  | |          | | |
|  |        |            +---------------+          | |        | |          | | |
|  |        |                                       | |        | |          | | |
|  |        |                 HTTP                  | |        | |          | | |
|  |        +-------------------------------------> | |        | |          | | |
|  |        |                                       | +--------+ +----------+ | |
|  +--------+                                       +-------------------------+ |
+-------------------------------------------------------------------------------+
```

## Usage

### Running locally

```
$ iex -S mix
```

Visit http://localhost:5002 for the UI.

### Running in a local Docker Swarm

https://docs.docker.com/engine/swarm/stack-deploy/

```shell
$ docker service create --name registry --publish published=5000,target=5000 registry:2

$ docker-compose -f swarm.yml push

$ docker stack deploy --compose-file swarm.yml archiver

```

- Visit http://localhost:5002 for UI.
- Visit http://localhost:9090 for Docker Visualizer.

