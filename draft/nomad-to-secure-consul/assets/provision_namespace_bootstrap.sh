#!/usr/bin/env bash

source /root/tls_environment

CONSUL_TOKEN_DIR=/root/consul/tokens
NOMAD_TOKEN_DIR=/root/nomad/tokens
CONSUL_POLICY_DIR=/root/consul/policy
NOMAD_POLICY_DIR=/root/nomad/policy

mkdir -p ${CONSUL_TOKEN_DIR} ${CONSUL_POLICY_DIR} ${NOMAD_TOKEN_DIR} ${NOMAD_POLICY_DIR}

bootstrap_consul() {
  echo -n Bootstrapping Consul ACLs..
  until consul acl bootstrap > ${CONSUL_TOKEN_DIR}/consul_bootstrap.token
  do
    echo -n "."
    sleep 2
  done
  echo "Done."
}

bootstrap_nomad() {
  echo -n Bootstrapping Nomad ACLs..
  until nomad acl bootstrap > ${NOMAD_TOKEN_DIR}/nomad_bootstrap.token
  do
    echo -n "."
    sleep 2
  done
  echo "Done."
}

source /root/tls_environment
bootstrap_consul
bootstrap_nomad
CONSUL_BOOTSTRAP_TOKEN=$(awk '/SecretID/ {print $2}' ${CONSUL_TOKEN_DIR}/consul_bootstrap.token)
export CONSUL_HTTP_TOKEN=${CONSUL_BOOTSTRAP_TOKEN}
consul acl policy create -name "consul_agent" -description "Consul Agent Token Policy" -rules @/tmp/consul_agent.consul.policy.hcl
consul acl policy create -name "nomad_server" -description "Nomad Server Token Policy" -rules @/tmp/nomad_server.consul.policy.hcl
consul acl policy create -name "nomad_client" -description "Nomad Client Token Policy" -rules @/tmp/nomad_client.consul.policy.hcl
consul acl token create -description "Consul Agent Token" -policy-name "consul_agent" | tee ${CONSUL_TOKEN_DIR}/consul_agent.consul.token
consul acl token create -description "Nomad Server Token" -policy-name "nomad_server" | tee ${CONSUL_TOKEN_DIR}/nomad_server.consul.token
consul acl token create -description "Consul Agent Token" -policy-name "nomad_client" | tee ${CONSUL_TOKEN_DIR}/nomad_client.consul.token
export CONSUL_AGENT_CONSUL_TOKEN=$(awk '/SecretID/ {print $2}' ${CONSUL_TOKEN_DIR}/consul_agent.consul.token)
consul acl set-agent-token agent ${CONSUL_AGENT_CONSUL_TOKEN}

export NOMAD_SERVER_CONSUL_TOKEN=$(awk '/SecretID/ {print $2}' ${CONSUL_TOKEN_DIR}/nomad_server.consul.token)
export NOMAD_CLIENT_CONSUL_TOKEN=$(awk '/SecretID/ {print $2}' ${CONSUL_TOKEN_DIR}/nomad_client.consul.token)
for I in {1..3}
do
  # set the server agent token
  ip netns exec server$I bash -c "CONSUL_HTTP_TOKEN=${CONSUL_BOOTSTRAP_TOKEN} consul acl set-agent-token agent ${CONSUL_AGENT_CONSUL_TOKEN}"

  ## Config Stuff
  sed -i "s/#{{TOKEN}}/token = \"${NOMAD_SERVER_CONSUL_TOKEN}\"/g" /opt/nomad/server$I/nomad.hcl
  restart_server$I
done
sed -i "s/#{{TOKEN}}/token = \"${NOMAD_CLIENT_CONSUL_TOKEN}\"/g" /opt/nomad/client/nomad.hcl
restart_client
