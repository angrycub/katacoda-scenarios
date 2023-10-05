## Client only configuration
client {
  enabled = true
  network_interface = "{{GetDefaultInterfaces | include \"type\" \"ipv4\" | attr \"name\"}}"
}
