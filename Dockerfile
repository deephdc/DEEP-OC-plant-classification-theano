FROM ubuntu:18.04
LABEL maintainer="Lara Lloret Iglesias <lloret@ifca.unican.es>"
LABEL version="0.1"
LABEL description="DEEP as a Service Container: Plant Classification"

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
        curl \
        git \
        python-setuptools \
        python-pip

# We could shrink the dependencies, but this is a demo container, so...
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
         build-essential \
         python-dev \
         python-wheel \
         python-numpy \
         python-scipy \
         python-tk

RUN pip install --upgrade https://github.com/Theano/Theano/archive/master.zip
RUN pip install --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip

WORKDIR /srv

RUN git clone https://github.com/indigo-dc/plant-classification-theano -b package && \
    cd plant-classification-theano && \
    pip install -e . && \
    cd ..

#Install deepaas
RUN pip install deepaas

ENV SWIFT_CONTAINER https://cephrgw01.ifca.es:8080/swift/v1/Plants/
ENV THEANO_TR_WEIGHTS resnet50_6182classes_100epochs.npz
ENV THEANO_TR_JSON resnet50_6182classes_100epochs.json
ENV SYNSETS synsets_binomial.txt
ENV INFO info.txt

RUN curl -o ./plant-classification-theano/plant_classification/training_weights/${THEANO_TR_WEIGHTS} \
    ${SWIFT_CONTAINER}${THEANO_TR_WEIGHTS}

RUN curl -o ./plant-classification-theano/plant_classification/training_info/${THEANO_TR_JSON} \
    ${SWIFT_CONTAINER}${THEANO_TR_JSON}

RUN curl -o ./plant-classification-theano/data/data_splits/synsets.txt \
    ${SWIFT_CONTAINER}${SYNSETS}

#RUN curl -o ./webpage/model_files/data/info.txt \
#    ${SWIFT_CONTAINER}${INFO}

# install rclone
RUN apt-get install -y wget nano && \
    wget https://downloads.rclone.org/rclone-current-linux-amd64.deb && \
    dpkg -i rclone-current-linux-amd64.deb && \
    apt install -f && \
    rm rclone-current-linux-amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /tmp/*

EXPOSE 5000

CMD deepaas-run --listen-ip 0.0.0.0

