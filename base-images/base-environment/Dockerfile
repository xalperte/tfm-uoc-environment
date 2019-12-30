FROM python:3.6.9-slim

# get the private and public key, this is used to clone the private repos
ARG ssh_prv_key
ARG ssh_pub_key

# Install all the dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        openssh-server \
        build-essential \
        curl \
        unzip \
        wget

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

# Remove dh key too small check on openssl
RUN sed -i "/\b\(CipherString = DEFAULT@SECLEVEL=2\)\b/d" /etc/ssl/openssl.cnf