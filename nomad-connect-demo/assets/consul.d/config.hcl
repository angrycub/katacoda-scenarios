log_level = "INFO"

server           = true
datacenter       = "dc1"
data_dir         = "/opt/consul/data"

# Typically this matches the number of Consul server members in your cluster
bootstrap_expect = 1
client_addr      = "0.0.0.0"

# This would generally point to the other Consul Servers in the cluster
# retry_join       = ["10.0.2.21","10.0.2.22","10.0.2.23"]

ui_config {
  enabled = true
}
