# colomoto-docker-base

[![](https://images.microbadger.com/badges/image/colomoto/colomoto-docker-base.svg)](http://microbadger.com/images/colomoto/colomoto-docker-base "Get your own image badge on microbadger.com")

## Quick usage guide

You need [Docker](http://docker.com).
First fetch the image with

    $ docker pull colomoto/colomoto-docker-base:TAG

where `TAG` is the version of the image, among [colomoto/colomoto-docker-base tags](https://hub.docker.com/r/colomoto/colomoto-docker-base/tags/).

The image can be ran using

    $ docker run -it --rm -p 8888:8888 colomoto/colomoto-docker-base:TAG

then, open your browser and go to http://localhost:8888 for the Jupyter notebook web interface
(note: when using Docker Toolbox, replace localhost with the result of
`docker-machine ip default` command).


## Embedded softwares

This image provides a base system for the [CoLoMoTo docker image](https://github.com/colomoto/colomoto-docker).

It contains a [conda](https://conda.io/miniconda.html) installation with the [Jupyter notebook](http://jupyter.org),
the [Pandas data analysis library](https://pandas.pydata.org/), and a [Java runtime](http://openjdk.java.net).
