FROM jupyter/all-spark-notebook:latest
# FROM jupyter/pyspark-notebook

LABEL maintainer="Xavier Alperte <javier.alperte@gmail.com>"

# Make pyarrow available in pyspark
RUN $CONDA_DIR/bin/pip install pyarrow pyspark[sql]

USER root

RUN pip install jupyter_contrib_nbextensions \
    && jupyter contrib nbextension install --system \
    && pip install jupyter_nbextensions_configurator \
    && jupyter nbextensions_configurator enable --system \
    && pip install yapf # for code pretty

RUN pip install dse-driver \
    && conda install -y pandas \
    && conda install -y -c conda-forge altair vega_datasets \
    && conda install -y -c conda-forge ipywidgets \
    && conda install -y nodejs \
    && pip install ipython-autotime

ADD requirements.txt /home/jovyan/

RUN pip install -r requirements.txt