source ~/tls_environment

bootstrap_consul() {
  echo -n Bootstrapping Consul ACLs..
  until consul acl bootstrap > consul_bootstrap.token
  do
    echo -n "."
    sleep 2
  done
  echo "Done."
}

bootstrap_nomad() {
  echo -n Bootstrapping Nomad ACLs..
  until nomad acl bootstrap > nomad_bootstrap.token
  do
    echo -n "."
    sleep 2
  done
  echo "Done."
}

ip netns exec server1 /usr/bin/env bash -c "
  source /root/tls_environment
  bootstrap_consul
  bootstrap_nomad
  export CONSUL_HTTP_TOKEN=\$(awk '/SecretID/ {print $2}' /root/consul_bootstrap.token)
  consul acl policy create -name \"consul_agent\" -description \"Consul Agent Token Policy\" -rules @/tmp/consul_agent.consul.policy.hcl
  consul acl policy create -name \"nomad_server\" -description \"Nomad Server Token Policy\" -rules @/tmp/nomad_server.consul.policy.hcl
  consul acl policy create -name \"nomad_client\" -description \"Nomad Client Token Policy\" -rules @/tmp/nomad_client.consul.policy.hcl
  consul acl token create -description \"Consul Agent Token\" -policy-name \"consul_agent\" | tee consul_agent.consul.token
  consul acl token create -description \"Nomad Server Token\" -policy-name \"nomad_server\" | tee nomad_server.consul.token
  consul acl token create -description \"Consul Agent Token\" -policy-name \"nomad_client\" | tee nomad_client.consul.token
  export CONSUL_AGENT_CONSUL_TOKEN=\$(awk '/SecretID/ {print $2}' consul_agent.consul.token)
  consul acl set-agent-token agent \${CONSUL_AGENT_CONSUL_TOKEN}
"
export NOMAD_SERVER_CONSUL_TOKEN=\$(awk '/SecretID/ {print $2}' nomad_server.consul.token)
export NOMAD_CLIENT_CONSUL_TOKEN=\$(awk '/SecretID/ {print $2}' nomad_client.consul.token)
for I in {1..3}
do
  ## Config Stuff
  sed -i "s/#{{TOKEN}}/token = \"$NOMAD_SERVER_CONSUL_TOKEN\"/g" /opt/nomad/server$I/nomad.hcl
  restart_server$I
done
sed -i "s/#{{TOKEN}}/token = \"$NOMAD_CLIENT_CONSUL_TOKEN\"/g" /opt/nomad/client/nomad.hcl
restart_client



