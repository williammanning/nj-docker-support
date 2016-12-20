# docker-support
files/configs to help dockerize apps

## .bashrc
the `.bashrc` file sets up some useful bash shortcuts.

## Dockerfile
the provided `Dockerfile` allows the running of a local node server inside a dockerized 'clean room'

To build the image. (copy the Dockerfile to the root of your project, and `cd` into the project root.) or replace the `.` with the full path to the Dockerfile.

```
$ docker build . -t <PROJECT-NAME>
```
The image will be built and the current folder will be copied into image,
then run the image with the following command
```
$ docker run -P -t <PROJECT-NAME>
```

if you want to use your local files instead of those copied in when the image was created use
the following
```
$ docker run -P -v ${pwd} /server -t <PROJECT-NAME>
```

to run the docker instance and open a terminal on the instance
use the following command
```
$ docker run -P -v ${pwd} /server -it <PROJECT-NAME> bash
```

e.g.

If i have a project called my-dumb-stuff
```
$ docker build . -t my-dumb-stuff
$ docker run -P -t my-dumb-stuff  # runs the container
$ docker run -P -v ${pwd} /server -it my-dumb-stuff # run the container and mounts the current folder
```
