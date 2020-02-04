# Container image that runs your code
FROM debian:buster-slim

RUN apt-get -y update; \
    apt-get -y install curl git; \
    curl -sL https://github.com/splitsh/lite/releases/download/v1.0.1/lite_linux_amd64.tar.gz -o lite_linux_amd64.tar.gz; \
    tar -zxpf lite_linux_amd64.tar.gz --directory /usr/local/bin/ 

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]