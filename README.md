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

Now you can run an instance of the created container over your local project

```

$ docker run -P -v ${PWD}:/server -t <PROJECT-NAME>
```

to run the docker instance and open a terminal on the instance
use the following command

```

$ docker run -P -v ${PWD}:/server -it <PROJECT-NAME> bash
```
This will start the container but wont run the embedded `CMD` so
you would have to start the server manually from inside the container.

e.g.

If i have a project called my-dumb-stuff,
copy the `Dockerfile` into the root folder of the project,
```

$ cd my-dumb-stuff
$ docker build . -t mds-cleanroom
$ docker run -P -t mds-cleanroom  # runs the container
$ docker run -P -v ${PWD}:/server -it mds-cleanroom # run the container and mounts the current folder
```

to run as a daemon
```

$ docker run --name mds-cleanroom -v ${PWD}:/server -d -it mds-cleanroom
d84e730a4e584717a9472a7b74b2c74ed59c60f127353c3a67eda1573edad119
$
```

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
