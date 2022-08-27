# Skill17-Environment

## How to create the Docker image
`docker build -t skill17image .`

## How to use the built image
* to store/edit the data inside the container `docker run -d --name skill17container -p 80:80 -p 8000:8000 -p 3306:3306 -p 22:22 -p 4200:4200 skill17image:latest`
* to store/edit the data in the host's current local folder `docker run -d --rm --name skill17container -v $(pwd):/var/www/html -w /var/www/html -p 80:80 -p 8000:8000 -p 3306:3306 -p 22:22 -p 4200:4200 skill17image:latest`

and then to execute commands either
* ssh into the container `ssh competitor@127.0.0.1`
* connect into the container `docker exec -it skill17container bash`

and to transfer files (if not in bind-mounted directory) either
* transfer local file into container: `scp mylocalsourcefile competitor@127.0.0.1:/var/www/myremotetargetfile`
* transfer file from container to local host: `scp competitor@127.0.0.1:/var/www/myremotesourcefile mylocaltargetfile`
* use sftp: `sftp competitor@127.0.0.1:/var/www/` (cli or any client like filezilla..)


## How to zip the files
* if they are stored in the local folder `tar --exclude='./node_modules' -zcf ../app.tar.gz .`
* if they are stored in the container `docker exec -it skill17container tar --exclude='./node_modules' -zcf /tmp/app.tar.gz /var/www/html/ && docker cp skill17container:/tmp/app.tar.gz ./app.tar.gz`


## Ports
* 22: ssh/sftp
* 80: http
* 3306: mysqlDB
* 4200: angular
* 8000: ?

