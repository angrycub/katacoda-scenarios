bind_addr        = "{{GetInterfaceIP \"ens3\"}}"
bootstrap_expect = 1
client_addr      = "0.0.0.0"
data_dir         = "/opt/consul/data"
datacenter       = "dc1"
log_level        = "DEBUG"
server           = true
ui               = true

connect {
  enabled = true
}

ports {
  grpc = 8502
}