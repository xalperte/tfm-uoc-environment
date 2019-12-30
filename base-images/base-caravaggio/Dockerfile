FROM xalperte/base-environment:0.1

# DB settings
ENV DB_HOST postgres_backend
ENV DB_PORT 5432

# Cassandra settings
ENV CASSANDRA_DB_HOST host.docker.internal
ENV CASSANDRA_DB_USER caravaggio
ENV CASSANDRA_DB_PASSWORD caravaggio

# SOLR connection information
ENV HAYSTACK_URL="http://host.docker.internal:8983/solr"

# REDIS connection information
ENV REDIS_HOST_PRIMARY redis_backend

# Install all the dependencies
RUN apt-get update && \
    apt-get install -y \
        libgdal-dev \
        libev4 \
        libev-dev

ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal

# install miniconda
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    mercurial subversion

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda2-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

RUN conda create -y -n tfm-uoc python=3.6 pip \
    && echo "source activate tfm-uoc" >> ~/.bashrc

ENV PATH /opt/conda/envs/tfm-uoc/bin:$PATH

RUN conda install -y gdal==2.3.3