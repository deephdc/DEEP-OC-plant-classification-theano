FROM ubuntu:18.04
LABEL maintainer="Alvaro Lopez Garcia <aloga@ifca.unican.es>"
LABEL version="0.1"
LABEL description="DEEP as a Service Generic Container"

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

RUN git clone https://github.com/indigo-dc/plant-classification-theano -b package && \
    cd plant-classification-theano && \
    pip install -e . && \
    cd ..

# TODO(aloga): use PyPi whenever possible
RUN git clone https://github.com/IFCA/deepaas && \
    cd deepaas && \
    pip install -U . && \
    cd ..

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python-tk

ENV SWIFT_CONTAINER https://cephrgw01.ifca.es:8080/swift/v1/Plants/
ENV THEANO_TR_WEIGHTS resnet50_6182classes_100epochs.npz
ENV THEANO_TR_JSON resnet50_6182classes_100epochs.json
ENV SYNSETS synsets_binomial.txt
ENV INFO info.txt

RUN curl -o ./plant-classification-theano/plant_classification/training_weights/${THEANO_TR_WEIGHTS} \
    ${SWIFT_CONTAINER}${THEANO_TR_WEIGHTS}

RUN curl -o ./plant-classification-theano/plant_classification/training_info/${THEANO_TR_JSON} \
    ${SWIFT_CONTAINER}${THEANO_TR_JSON}

RUN curl -o ./plant-classification-theano/data/data_splits/synsets_binomial.txt \
    ${SWIFT_CONTAINER}${SYNSETS}

#RUN curl -o ./webpage/model_files/data/info.txt \
#    ${SWIFT_CONTAINER}${INFO}


EXPOSE 5000

CMD deepaas-run
