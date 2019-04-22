#!/bin/bash

# from TVM official version
# https://github.com/dmlc/tvm/blob/master/docker/install/ubuntu_install_core.sh

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

set -e
set -u
set -o pipefail

# install libraries for building c++ core on ubuntu
apt-get update && apt-get install -y --no-install-recommends \
        git make libgtest-dev cmake wget unzip libtinfo-dev libz-dev\
        libcurl4-openssl-dev libopenblas-dev g++ sudo 
#apt-get update && apt-get install -y --no-install-recommends --fix-missing \
#apt-get update && apt-get install -y --fix-missing \
#        git make libgtest-dev cmake wget unzip libtinfo-dev libz-dev\
#        python3 python3-dev python3-setuptools\
#        zlib1g-dev build-essential g++ sudo
#cd /usr/src/gtest && cmake CMakeLists.txt && make && cp *.a /usr/lib
