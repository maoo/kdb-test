#!/bin/bash

export KAFKA_ROOT=/usr
export PATH=$PATH:${PWD}/l64
export QHOME=${PWD}
export LD_LIBRARY_PATH=$HOME/lib:/usr/lib
export TOOLING_ARCHIVE="https://api.github.com/repos/finos/tooling/contents/archive.zip"

# Install and run Kafka with Zookeeper
curl -O http://apache.rediris.es/kafka/2.0.0/kafka_2.12-2.0.0.tgz
tar -xzf kafka_2.12-2.0.0.tgz
cd kafka_2.12-2.0.0
./bin/zookeeper-server-start.sh config/zookeeper.properties &
./bin/kafka-server-start.sh config/server.properties &

# Download other tools needed
curl -O --header "Authorization: token $GH_TOKEN" \
  --header 'Accept: application/vnd.github.v3.raw' \
  --remote-name \
  --location $TOOLING_ARCHIVE

unzip archive.zip

# Copy libs and include
mkdir -p ${HOME}/lib
sudo cp -Rf /usr/lib/* ${HOME}/lib/
mkdir -p ${HOME}/include
sudo cp -Rf /usr/include/* ${HOME}/include/

# Build and install kdb+ to Apache Kafka adapter
git clone https://github.com/KxSystems/kafka.git
cd kafka
make
make install