Open your nomad configuration file. For this lab it is `nomad_config.hcl`{{open}}

Add your encryption token to the `server` stanza.

```hcl
server {
  # ...

  # Encrypt gossip communication
  encrypt = "cg8StVXbQJ0gPvMd9o7yrg=="

  # ...
}
```
