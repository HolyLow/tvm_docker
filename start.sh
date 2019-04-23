#!/usr/bin/env bash

# modified by Jiaming Xie from the TVM official docker scripts,
# please refer to 
# https://github.com/dmlc/tvm/blob/master/docker/bash.sh


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

#
# Start a bash, mount /tvm_workspace to be the tvm_workspace sub-directory.
#
# 
# Usage: start.sh
#     Starts an interactive session with default image 
#
# Usage2: start.sh <IMAGE_NAME> 
#     Starts an interactive session with required image
#

DOCKER_IMAGE_NAME="holylow/tvm-cpu:latest"

if [ "$#" -gt 0 ]; then
    DOCKER_IMAGE_NAME=("$1")
fi

DOCKER_BINARY="docker"
COMMAND="/bin/bash"
CI_DOCKER_EXTRA_PARAMS=("-it --net=host")
WORKSPACE="$(pwd)/tvm_workspace"
mkdir -p ${WORKSPACE}
CONTAINER_HOST_NAME="tvm-docker"

# Print arguments.
echo "WORKSPACE: ${WORKSPACE}"
echo "DOCKER IMAGE NAME: ${DOCKER_IMAGE_NAME}"
echo ""

# By default we cleanup - remove the container once it finish running (--rm)
# and share the PID namespace (--pid=host) so the process inside does not have
# pid 1 and SIGKILL is propagated to the process inside (jenkins can kill it).

${DOCKER_BINARY} run --rm --pid=host \
    -v ${WORKSPACE}:/tvm_workspace \
    -w /workspace \
    -e "CI_BUILD_HOME=/tvm_workspace" \
    -e "CI_BUILD_USER=$(id -u -n)" \
    -e "CI_BUILD_UID=$(id -u)" \
    -e "CI_BUILD_GROUP=$(id -g -n)" \
    -e "CI_BUILD_GID=$(id -g)" \
    -e "PYTHONPATH=python:topi/python"\
    -h ${CONTAINER_HOST_NAME} \
    ${CI_DOCKER_EXTRA_PARAMS[@]} \
    ${DOCKER_IMAGE_NAME} \
    /bin/bash
