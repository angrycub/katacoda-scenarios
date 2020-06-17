#!/usr/bin/env bash

CONSUL_TOKEN_DIR=/root/consul/tokens
NOMAD_TOKEN_DIR=/root/nomad/tokens
CONSUL_POLICY_DIR=/root/consul/policy
NOMAD_POLICY_DIR=/root/nomad/policy

ip netns exec server1 /usr/local/bin/provision_namespace_bootstrap.sh

# Set the Consul Client ACL token
export CONSUL_BOOTSTRAP_TOKEN=$(awk '/SecretID/ {print $2}' ${CONSUL_TOKEN_DIR}/consul_bootstrap.token)
export CONSUL_HTTP_TOKEN=${CONSUL_BOOTSTRAP_TOKEN}
export CONSUL_AGENT_CONSUL_TOKEN=$(awk '/SecretID/ {print $2}' ${CONSUL_TOKEN_DIR}/consul_agent.consul.token)
consul acl set-agent-token agent ${CONSUL_AGENT_CONSUL_TOKEN}
