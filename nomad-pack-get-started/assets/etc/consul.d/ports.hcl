ports {
  server   = 8300   # tcp
  serf_lan = 8301   # tcp,udp
  serf_wan = 8302   # tcp,udp
  http     = 8500   # tcp
  https    = 8501   # tcp
  grpc     = 8502   # tcp
  grpc_tls = 8503   # tcp
  dns      = 8600   # tcp,udp

  sidecar_min_port = 21000 # tcp
  sidecar_max_port = 21255 # tcp
  expose_min_port  = 21500 # tcp,udp
  expose_max_port  = 21755 # tcp,udp
}
