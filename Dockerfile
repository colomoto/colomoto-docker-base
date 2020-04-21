FROM debian:stable-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

ARG USER=user
ARG USER_UID=1000
RUN useradd -u $USER_UID -m -d /notebook -s /bin/bash $USER

EXPOSE 8888
WORKDIR /notebook
ENTRYPOINT ["/usr/bin/tini", "--", "colomoto-env"]
CMD ["colomoto-nb", "--NotebookApp.token="]

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

RUN TINI_VERSION="0.19.0" && \
    wget --quiet https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}-amd64.deb && \
    dpkg -i tini_${TINI_VERSION}-amd64.deb && \
    rm *.deb

RUN CONDA_VERSION="py37_4.8.2" && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    conda update -n base -c defaults conda && \
    conda config --set auto_update_conda False && \
    conda config --add channels conda-forge && \
    conda config --add channels colomoto && \
    conda install --no-update-deps -y \
        -c colomoto/label/fake \
        pyqt && \
    conda install -y \
        libgfortran \
        ipywidgets \
        'matplotlib>=1.3.1' \
        networkx \
        nomkl \
        notebook \
        openjdk=8.0.144 \
        pandas \
        pydot \
        'pygraphviz>=1.5' \
        rpy2 \
        seaborn \
        && \
    rm /opt/conda/jre/src.zip && \
    conda clean -y --all && rm -rf /opt/conda/pkgs

COPY bin/* /usr/bin/

USER user
