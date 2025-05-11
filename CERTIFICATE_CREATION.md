# HOW TO CREATE AN SSL CERTIFICATE

## SSL Certificate Creation Example
Launch an Alpine docker container:
```
mkdir -p /tmp/cert
docker run -it --rm -v /tmp/cert:/cert alpine:latest
```
Inside the container we are going to create our files:
```
apk update
apk add openssl
cd /cert
# This will create a key file and a certificate file
openssl req -newkey rsa:2048 -nodes -keyout stunnel.key -x509 -days 365 -out stunnel.crt
# This will create a single file with the key and certificate
openssl req -newkey rsa:2048 -nodes -keyout stunnel.pem -x509 -days 365 -out stunnel.pem
# You can add -subj to make this a non-interactive process
# -subj "/C=US/ST=New York/L=Brooklyn/O=Example Brooklyn Company/CN=examplebrooklyn.com"
logout
```
Now you can use these files (located in /tmp/cert) inside your stunnel container
