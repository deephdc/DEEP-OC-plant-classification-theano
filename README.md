# DEEP as a Service container for plant classification

![DEEP-Hybrid-DataCloud logo](https://deep-hybrid-datacloud.eu/wp-content/uploads/2018/01/logo.png)

[![Build Status](https://jenkins.indigo-datacloud.eu:8080/buildStatus/icon?job=Pipeline-as-code/DEEP-OC-org/DEEP-OC-plant-classification-theano/master)](https://jenkins.indigo-datacloud.eu:8080/job/Pipeline-as-code/job/DEEP-OC-org/job/DEEP-OC-plant-classification-theano/job/master)

This is a container that will run the DEEP as a Service API component,
with an application to classify plant images. This module runs in Lasagne on top of Theano and uses a convolutional neural network (ResNet50) as model.

# Running the container

## Directly from Docker Hub

To run the Docker container directly from Docker Hub and start using the API
simply run the following command:

```bash
$ docker run -ti -p 5000:5000 deephdc/deep-oc-plant-classification-theano
```

This command will pull the Docker container grom the Docker Hub
[`deephdc`](https://hub.docker.com/u/deephdc/) organization.

## Building the container

If you want to build the container directly in your machine (because you want
to modify the `Dockerfile` for instance) follow the following instructions:

Building the container:

1. Get the `DEEP-OC-plant-classification` repository (this repo):

    ```bash
    $ git clone https://github.com/indigo-dc/DEEP-OC-plant-classification-theano
    ```

2. Build the container:

    ```bash
    $ cd DEEP-OC-plant-classification-theano
    $ docker build -t deephdc/deep-oc-plant-classification-theano .
    ```

3. Run the container:

    ```bash
    $ docker run -ti -p 5000:5000 deephdc/deep-oc-plant-classification-theano
    ```

These three steps will download the repository from GitHub and will build the
Docker container locally on your machine. You can inspect and modify the
`Dockerfile` in order to check what is going on. For instance, you can pass the
`--debug=True` flag to the `deepaas-run` command, in order to enable the debug
mode.

# Connect to the API

Once the container is up and running, browse to `http://localhost:5000` to get
the [OpenAPI (Swagger)](https://www.openapis.org/) documentation page.
