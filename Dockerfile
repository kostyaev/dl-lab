FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
LABEL maintainer="dmitry@kostyaev.me"

# caffe2 without gpu support
# pytorch, tensorflow with gpu suppor

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libgflags-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libiomp-dev \
    libleveldb-dev \
    liblmdb-dev \
    libopencv-dev \
    libopenmpi-dev \
    libprotobuf-dev \
    libsnappy-dev \
    openmpi-bin \
    openmpi-doc \
    protobuf-compiler \
    python-dev \
    python-numpy \
    python-pip \
    python-pydot \
    python-setuptools \
    python-scipy \
    wget \
    curl \
    vim \
    ca-certificates \
    libnccl2=2.0.5-2+cuda8.0 \
    libnccl-dev=2.0.5-2+cuda8.0 \
    libjpeg-dev \
    libpng-dev \
    && rm -rf /var/lib/apt/lists/*


RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir \
    flask \
    future \
    graphviz \
    hypothesis \
    jupyter \
    matplotlib \
    numpy \
    protobuf \
    pydot \
    python-nvd3 \
    pyyaml \
    requests \
    scikit-image \
    scipy \
    setuptools \
    six \
    tornado

########## INSTALLATION STEPS ###################
RUN git clone --recursive https://github.com/caffe2/caffe2.git && cd caffe2
RUN cd caffe2 && mkdir build && cd build \
    && cmake .. \
    -DUSE_CUDA=OFF \
    -DUSE_ROCKSDB=OFF \
    && make -j"$(nproc)" install \
    && ldconfig \
    && make clean \
    && cd .. \
    && rm -rf build

ENV PYTHONPATH /usr/local

RUN apt-get update && apt-get install -y libblas-dev liblapack-dev
RUN git clone --recursive https://github.com/pytorch/pytorch && \
    cd pytorch && \
    python setup.py install

RUN git clone https://github.com/pytorch/vision.git && cd vision && pip install -v .
RUN pip install onnx onnx-caffe2
RUN pip install tensorflow-gpu
RUN pip install keras


# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /root/
RUN chmod +x /root/run_jupyter.sh

# Expose Ports for TensorBoard (6006), Ipython (8888)
EXPOSE 6006 8888

WORKDIR "/root"
CMD ["./run_jupyter.sh"]