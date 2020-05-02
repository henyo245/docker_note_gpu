FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

# refs. Install Python3.7 in ubuntu 16.04
# https://medium.com/@manivannan_data/install-python3-7-in-ubuntu-16-04-dfd9b4f11e5c
RUN apt update && apt-get install -y \
    build-essential \
    checkinstall \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    zlib1g-dev \
    openssl \
    libffi-dev \
    python3-dev \
    python3-setuptools \
    wget \
    && mkdir /tmp/Python36
WORKDIR tmp/Python36
RUN wget https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tar.xz \
    && tar xvf Python-3.6.0.tar.xz
WORKDIR /tmp/Python36/Python-3.6.0
RUN ./configure --enable-optimizations \
    && make altinstall \
    && mkdir /usr/local/Python

#install pip
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py

#install library
RUN pip install --upgrade pip
RUN pip install jupyter
#RUN pip install chainer
RUN pip install opencv-python
RUN pip install pandas==0.24.1
RUN pip install numpy
#RUN pip install cupy
RUN pip install GPy
RUN pip install gpyopt
RUN pip install pydicom
RUN pip install scikit-learn
RUN pip install spicy
RUN pip install scikit-image
RUN pip install matplotlib
RUN pip install xlrd
RUN pip install xlwt
RUN pip install XlsxWriter
RUN pip install Imagehash
RUN pip install keras==2.2.4
RUN pip install tensorflow-gpu==1.4.0
RUN pip install optuna
#RUN pip install torch
#RUN pip install torchvision
RUN pip install progressbar2

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    emacs \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    python-dev \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    tzdata \
    unzip \
    nano \
    && rm -rf /var/lib/apt/lists/*

#setup jupyter
RUN jupyter notebook --generate-config && \
    sed -i -e "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/" /root/.jupyter/jupyter_notebook_config.py && \
    sed -i -e "s/#c.NotebookApp.allow_remote_access = False/c.NotebookApp.allow_remote_access = True/" /root/.jupyter/jupyter_notebook_config.py
   
WORKDIR /tmp

# Expose container ports
EXPOSE 8888
