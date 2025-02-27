# postfix-docker-from-source
This is the a base dockerfile to build postfix from source inside a docker container

This currently compiles Postfix 10.3.1 - composing a images will create a running postfix inside a container. 
The config files will be copied inside the container during building. 

I use this to setup fasten secure outgoing mail services. 
