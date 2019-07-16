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


RUN TINI_VERSION="0.18.0" && \
    wget --quiet https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}-amd64.deb && \
    dpkg -i tini_${TINI_VERSION}-amd64.deb && \
    rm *.deb

RUN CONDA_VERSION="4.6.14" && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    conda config --set auto_update_conda False && \
    conda config --add channels conda-forge && \
    conda config --add channels bioconda && \
    conda config --add channels colomoto && \
    conda install --no-update-deps -y \
        -c colomoto/label/fake \
        pyqt=5.9.9999=0 && \
    conda install --no-update-deps -y \
        ipywidgets=7.5.0=py_0 \
        matplotlib=3.1.1=py37_0 \
        networkx=2.3=py_0 \
        nomkl \
        notebook=6.0.0=py37_0 \
        openjdk=8.0.144 \
        pandas=0.24.2=py37hf484d3e_0 \
        pydot=1.4.1=py37_1000 \
        pygraphviz=1.5=py37h470a237_0 \
        rpy2=2.9.4=py37r351h941a26a_1 \
        seaborn=0.9.0=py_1 \
        simplegeneric=0.8.1=py_1 \
        && \
    rm /opt/conda/jre/src.zip && \
    conda clean -y --all && rm -rf /opt/conda/pkgs

ARG USER_UID=1000
RUN useradd -u $USER_UID -m -d /notebook -s /bin/bash user
USER user

EXPOSE 8888
WORKDIR /notebook
ENTRYPOINT ["/usr/bin/tini", "--", "colomoto-env"]
CMD ["colomoto-nb", "--NotebookApp.token="]
COPY bin/* /usr/bin/

