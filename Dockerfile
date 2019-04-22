# This script is based on dockerfile provided by TVM, and 
# modified by Jiaming Xie.
# To get the original version, please refer to 
# https://github.com/dmlc/tvm/blob/master/docker/Dockerfile.demo_cpu


# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# Minimum docker image for demo purposes
# prebuilt-image: tvmai/demo-cpu

FROM ubuntu:16.04

ENV VER=00

RUN mv /etc/apt/sources.list /etc/apt/sources.list.old
COPY util/domestic_resources.list /etc/apt/sources.list
RUN apt-get update --fix-missing

COPY install/ubuntu_install_core.sh /install/ubuntu_install_core.sh
RUN bash /install/ubuntu_install_core.sh

# Python: basic dependencies
#RUN apt-get update && apt-get install -y python3-dev python3-pip
#RUN pip3 install numpy nose-timer cython decorator scipy
#RUN sudo apt-get install -y python python-dev python-setuptools gcc \
RUN sudo apt-get install -y python3 python3-dev python3-setuptools gcc \
         libtinfo-dev zlib1g-dev build-essential cmake


# LLVM
#RUN echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main \
#     >> /etc/apt/sources.list.d/llvm.list && \
#     wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add - && \
#     apt-get update && apt-get install -y --force-yes llvm-6.0

RUN echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main \
     >> /etc/apt/sources.list.d/llvm.list && \
     wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add - && \
     apt-get update && apt-get install -y --force-yes llvm-8

#RUN deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main
#RUN deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main

# Jupyter notebook.
RUN sudo apt-get install -y python3-pip
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple \
         matplotlib Image Pillow jupyter[notebook]

# Deep learning frameworks
#RUN pip3 install mxnet tensorflow keras gluoncv
RUN python3 -m pip install --upgrade torch torchvision \
            -i https://pypi.tuna.tsinghua.edu.cn/simple

# Build TVM
COPY install/install_tvm_cpu.sh /install/install_tvm_cpu.sh
RUN bash /install/install_tvm_cpu.sh


RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple \
         numpy decorator attrs tornado psutil xgboost
# Environment variables
#ENV PYTHONPATH=/usr/tvm/python:/usr/tvm/topi/python:/usr/tvm/nnvm/python/:/usr/tvm/vta/python:${PYTHONPATH}
ENV PYTHONPATH=/usr/tvm/python:/usr/tvm/topi/python:/usr/tvm/nnvm/python/:${PYTHONPATH}
