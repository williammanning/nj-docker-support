# docker-support
files/configs to help dockerize apps

## .bashrc
the `.bashrc` file sets up some useful bash shortcuts.

## Dockerfile
the provided `Dockerfile` allows the running of a local node server inside a dockerized 'clean room'

To build the image. (copy the Dockerfile to the root of your project, and `cd` into the project root.) or replace the `.` with the full path to the Dockerfile.

The docker file contains an `EXPOSE` statement and `CMD` to run the server, these should be changed to reflect the startup
cmdline for your instance.

The default `EXPOSE` command opens some standard development ports for mapping to the client machine.

`EXPOSE 3001 3002 8000 8001 8002 8080 8181`

The default 'CMD' command starts the server by runnings `npm start`.

`CMD ["npm", "start"]`

 We should try to keep all servers as close to a simple `npm start` if possible.

```

$ docker build . -t <PROJECT-NAME>
```

|      options      |  description   |
|:------------------|:---------------|
|`-t <PROJECT-NAME>`|specify name:tag|

Now you can run an instance of the created container over your local project

```

$ docker run  -p <local_port>:<container_port> -v ${PWD}:/server -t <PROJECT-NAME>
```
|      options      |  description   |
|:------------------|:---------------|
|`-p  <local_port>:<container_port>`| specify port mapping|
|`-v ${PWD}:/server` | mount volume at /server inside the container|
|`-t` | attach a tty to the process.|

to run the docker instance and open a terminal on the instance
use the following command

```

$ docker run -p <local_port>:<container_port> -v ${PWD}:/server -it <PROJECT-NAME> bash
```
| options | description |
|:--------|:------------|
|`-i`| interactive|

This will start the container but wont run the embedded `CMD` so
you would have to start the server manually from inside the container.

e.g.

If i have a project called my-dumb-stuff,
copy the `Dockerfile` into the root folder of the project,
```

$ cd my-dumb-stuff
$ docker build . -t mds-cleanroom
$ docker run  -p 3001:3001 -t mds-cleanroom  # runs the container
$ docker run  -p 3001:3001 -v ${PWD}:/server -it mds-cleanroom # run the container and mounts the current folder
```

to run as a daemon
```

$ docker run -p 3001:3001 --name mds-cleanroom -v ${PWD}:/server -d -it mds-cleanroom
d84e730a4e584717a9472a7b74b2c74ed59c60f127353c3a67eda1573edad119
$
```
| options | description |
|:--------|:------------|
|`--name <container_name>`| assign name to container|

attach a bash session to a daemon container

```
$ docker exec -it mds-cleanroom bash
[1][root@d84e730a4e58: server]$ ps
PID   USER     TIME   COMMAND
    1 root       0:00 npm
   15 root       0:00 sh -c node viber.js # start quiz-express
   16 root       0:00 node viber.js
   26 root       0:00 bash
   40 root       0:00 ps
[2][root@d84e730a4e58: server]$
```

## Docker build
```
Usage:	docker build [OPTIONS] PATH | URL | -

Build an image from a Dockerfile

Options:
      --build-arg value         Set build-time variables (default [])
      --cgroup-parent string    Optional parent cgroup for the container
      --cpu-period int          Limit the CPU CFS (Completely Fair Scheduler) period
      --cpu-quota int           Limit the CPU CFS (Completely Fair Scheduler) quota
  -c, --cpu-shares int          CPU shares (relative weight)
      --cpuset-cpus string      CPUs in which to allow execution (0-3, 0,1)
      --cpuset-mems string      MEMs in which to allow execution (0-3, 0,1)
      --disable-content-trust   Skip image verification (default true)
  -f, --file string             Name of the Dockerfile (Default is 'PATH/Dockerfile')
      --force-rm                Always remove intermediate containers
      --help                    Print usage
      --isolation string        Container isolation technology
      --label value             Set metadata for an image (default [])
  -m, --memory string           Memory limit
      --memory-swap string      Swap limit equal to memory plus swap: '-1' to enable unlimited swap
      --no-cache                Do not use cache when building the image
      --pull                    Always attempt to pull a newer version of the image
  -q, --quiet                   Suppress the build output and print image ID on success
      --rm                      Remove intermediate containers after a successful build (default true)
      --shm-size string         Size of /dev/shm, default value is 64MB
  -t, --tag value               Name and optionally a tag in the 'name:tag' format (default [])
      --ulimit value            Ulimit options (default [])
```

## Docker run
```
Usage:	docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run a command in a new container

Options:
      --add-host value              Add a custom host-to-IP mapping (host:ip) (default [])
  -a, --attach value                Attach to STDIN, STDOUT or STDERR (default [])
      --blkio-weight value          Block IO (relative weight), between 10 and 1000
      --blkio-weight-device value   Block IO weight (relative device weight) (default [])
      --cap-add value               Add Linux capabilities (default [])
      --cap-drop value              Drop Linux capabilities (default [])
      --cgroup-parent string        Optional parent cgroup for the container
      --cidfile string              Write the container ID to the file
      --cpu-percent int             CPU percent (Windows only)
      --cpu-period int              Limit CPU CFS (Completely Fair Scheduler) period
      --cpu-quota int               Limit CPU CFS (Completely Fair Scheduler) quota
  -c, --cpu-shares int              CPU shares (relative weight)
      --cpuset-cpus string          CPUs in which to allow execution (0-3, 0,1)
      --cpuset-mems string          MEMs in which to allow execution (0-3, 0,1)
  -d, --detach                      Run container in background and print container ID
      --detach-keys string          Override the key sequence for detaching a container
      --device value                Add a host device to the container (default [])
      --device-read-bps value       Limit read rate (bytes per second) from a device (default [])
      --device-read-iops value      Limit read rate (IO per second) from a device (default [])
      --device-write-bps value      Limit write rate (bytes per second) to a device (default [])
      --device-write-iops value     Limit write rate (IO per second) to a device (default [])
      --disable-content-trust       Skip image verification (default true)
      --dns value                   Set custom DNS servers (default [])
      --dns-opt value               Set DNS options (default [])
      --dns-search value            Set custom DNS search domains (default [])
      --entrypoint string           Overwrite the default ENTRYPOINT of the image
  -e, --env value                   Set environment variables (default [])
      --env-file value              Read in a file of environment variables (default [])
      --expose value                Expose a port or a range of ports (default [])
      --group-add value             Add additional groups to join (default [])
      --health-cmd string           Command to run to check health
      --health-interval duration    Time between running the check
      --health-retries int          Consecutive failures needed to report unhealthy
      --health-timeout duration     Maximum time to allow one check to run
      --help                        Print usage
  -h, --hostname string             Container host name
  -i, --interactive                 Keep STDIN open even if not attached
      --io-maxbandwidth string      Maximum IO bandwidth limit for the system drive (Windows only)
      --io-maxiops uint             Maximum IOps limit for the system drive (Windows only)
      --ip string                   Container IPv4 address (e.g. 172.30.100.104)
      --ip6 string                  Container IPv6 address (e.g. 2001:db8::33)
      --ipc string                  IPC namespace to use
      --isolation string            Container isolation technology
      --kernel-memory string        Kernel memory limit
  -l, --label value                 Set meta data on a container (default [])
      --label-file value            Read in a line delimited file of labels (default [])
      --link value                  Add link to another container (default [])
      --link-local-ip value         Container IPv4/IPv6 link-local addresses (default [])
      --log-driver string           Logging driver for the container
      --log-opt value               Log driver options (default [])
      --mac-address string          Container MAC address (e.g. 92:d0:c6:0a:29:33)
  -m, --memory string               Memory limit
      --memory-reservation string   Memory soft limit
      --memory-swap string          Swap limit equal to memory plus swap: '-1' to enable unlimited swap
      --memory-swappiness int       Tune container memory swappiness (0 to 100) (default -1)
      --name string                 Assign a name to the container
      --network string              Connect a container to a network (default "default")
      --network-alias value         Add network-scoped alias for the container (default [])
      --no-healthcheck              Disable any container-specified HEALTHCHECK
      --oom-kill-disable            Disable OOM Killer
      --oom-score-adj int           Tune host's OOM preferences (-1000 to 1000)
      --pid string                  PID namespace to use
      --pids-limit int              Tune container pids limit (set -1 for unlimited)
      --privileged                  Give extended privileges to this container
  -p, --publish value               Publish a container's port(s) to the host (default [])
  -P, --publish-all                 Publish all exposed ports to random ports
      --read-only                   Mount the container's root filesystem as read only
      --restart string              Restart policy to apply when a container exits (default "no")
      --rm                          Automatically remove the container when it exits
      --runtime string              Runtime to use for this container
      --security-opt value          Security Options (default [])
      --shm-size string             Size of /dev/shm, default value is 64MB
      --sig-proxy                   Proxy received signals to the process (default true)
      --stop-signal string          Signal to stop a container, SIGTERM by default (default "SIGTERM")
      --storage-opt value           Storage driver options for the container (default [])
      --sysctl value                Sysctl options (default map[])
      --tmpfs value                 Mount a tmpfs directory (default [])
  -t, --tty                         Allocate a pseudo-TTY
      --ulimit value                Ulimit options (default [])
  -u, --user string                 Username or UID (format: <name|uid>[:<group|gid>])
      --userns string               User namespace to use
      --uts string                  UTS namespace to use
  -v, --volume value                Bind mount a volume (default [])
      --volume-driver string        Optional volume driver for the container
      --volumes-from value          Mount volumes from the specified container(s) (default [])
  -w, --workdir string              Working directory inside the container
```
