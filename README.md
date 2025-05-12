# stunnel-alpine
A small docker image running stunnel-server

## Base Docker Image
[Alpine](https://hub.docker.com/_/alpine) (x64)

## Software
[stunnel](https://www.stunnel.org/) - A GPL licensed FTP server

## Get the image from DockerHub or build it locally
```
docker pull fullaxx/stunnel-alpine
docker build -t="fullaxx/stunnel-alpine" github.com/Fullaxx/stunnel-alpine
```

## Networking Options
There are 2 environment variables that must be specified: ACCEPT and CONNECT \
These values will go directly into your stunnel.conf file \
ACCEPT will define the listening socket
```
-p 76.51.51.84:443:443 -e ACCEPT=443
--network=host -e ACCEPT=76.51.51.84:443
```
CONNECT will define the backend service connection
```
-e CONNECT=172.17.0.1:80
```

## Certificate Options
There are 2 ways to provide certificate/key files to stunnel \
In both cases the files must be provided in a volume called /certs \
You can provide a single key+certificate pem file:
```
-v /srv/docker/mydomain/mycerts:/certs -e CERTFILE=stunnel.pem
-v /srv/docker/mydomain/mycerts:/certs -e CERTFILE=stunnel.pem -e KEYFILE=stunnel.pem
```
You can provide a certificate file along with a seperate key file:
```
-v /srv/docker/mydomain/mycerts:/certs -e CERTFILE=stunnel.crt -e KEYFILE=stunnel.key
```

## Logging Options
By default, logging will be done on stdout/stderr. \
If you would like to see the stunnel logs on your host machine
```
FIXME NOT COMPLETE
-v /srv/docker/stunnel4/logs:/var/log/stunnel4
```

## Run the image
Run the image listening on 76.51.51.84:443 and connecting to 172.17.0.1:80 using a single PEM file
```
docker run -d \
-p 76.51.51.84:443:443 -e ACCEPT=443 -e CONNECT=172.17.0.1:80 \
-v /srv/docker/mydomain/mycerts:/certs -e CERTFILE=stunnel.pem \
fullaxx/stunnel-alpine
```
Run the image listening on 76.51.51.84:443 and connecting to 172.17.0.1:80 using seperate PEM files
```
docker run -d \
-p 76.51.51.84:443:443 -e ACCEPT=443 -e CONNECT=172.17.0.1:80 \
-v /srv/docker/mydomain/mycerts:/certs -e CERTFILE=stunnel.crt -e KEYFILE=stunnel.key \
fullaxx/stunnel-alpine
```
Run the image with host networking
```
docker run -d \
--network=host -e ACCEPT=76.51.51.84:443 -e CONNECT=172.17.0.1:80 \
-v /srv/docker/mydomain/mycerts:/certs -e CERTFILE=stunnel.pem \
fullaxx/stunnel-alpine
```

## Create a self-signed certificate
For a quick example on SSL certificate creation, [go here](CERTIFICATE_CREATION.md)

## Posting Issues on Github
When posting issues, please provide the following:
* docker run line used to create the container
* stunnel config file: docker exec -it <CONTAINER> cat /etc/stunnel/stunnel.conf
* output from docker logs
* screenshot showing the issue if not described in logs
* any other relevant networking information
