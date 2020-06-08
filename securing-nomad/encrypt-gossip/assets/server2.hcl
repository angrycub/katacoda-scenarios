data_dir  = "/opt/nomad/server2/data"
log_level = "DEBUG"
bind_addr = "192.168.0.12"

client {
  enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

server {
  enabled          = true
  bootstrap_expect = 1
}