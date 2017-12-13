FROM debian:stretch-slim
MAINTAINER CoLoMoTo Group <contact@colomoto.org>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    mkdir /usr/share/man/man1 && touch /usr/share/man/man1/rmid.1.gz.dpkg-tmp && \
    apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        wget \
        libxrender1 libice6 libxext6 libsm6 \
        && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*


RUN TINI_VERSION="0.16.1" && \
    wget --quiet https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}-amd64.deb && \
    dpkg -i tini_${TINI_VERSION}-amd64.deb && \
    rm *.deb

RUN CONDA_VERSION="4.3.30" && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    conda config --set auto_update_conda False && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda config --add channels colomoto && \
    conda install --no-update-deps  -y \
        ipywidgets \
        matplotlib \
        networkx=2.0 \
        nomkl \
        notebook \
        openjdk=8.0.144 \
        pandas \
        pydot \
        pygraphviz \
        && \
    rm /opt/conda/jre/src.zip && \
    conda clean -y --all && rm -rf /opt/conda/pkgs

EXPOSE 8888
WORKDIR /notebook
ENTRYPOINT ["/usr/bin/tini", "--", "colomoto-env"]
CMD ["colomoto-nb", "--NotebookApp.token="]
COPY bin/* /usr/bin/

