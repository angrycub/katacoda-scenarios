#! /usr/bin/env bash

for I in {1..3}; do stop_server$I; done
stop_client

for I in {1..3}
do 
  rm -rf /opt/nomad/server$I/data/* /opt/consul/server$I/data/* /opt/nomad/server$I/logs/* /opt/consul/server$I/logs/*
  sed "s/{{NODE}}/server$I/g" /tmp/nomad.server.hcl.template > /opt/nomad/server$I/nomad.hcl
  sed "s/{{NODE}}/server$I/g" /tmp/consul.server.hcl.template > /opt/consul/server$I/consul.hcl
done

rm -rf /opt/nomad/client/data/* /opt/server/client/data/* /opt/nomad/client/logs/* /opt/server/client/logs/*
sed "s/{{NODE}}/client/g" /tmp/consul.client.hcl.template > /opt/consul/client/consul.hcl
sed "s/{{NODE}}/client/g" /tmp/nomad.client.hcl.template > /opt/nomad/client/nomad.hcl


for I in {1..3}; do start_server$I; done
start_client
