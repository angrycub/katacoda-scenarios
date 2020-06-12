<style type="text/css">
.lang-screenshot { -webkit-touch-callout: none; -webkit-user-select: none; -khtml-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; }
</style>

The token value needs to be set within the consul stanza. If you don't have one,
add a consul stanza with your token.

```hcl
consul {
  token = "«your nomad agent token»"
}
```

For this hands-on lab. you can automate this process by running this command,
which will extract the secret from the token file that you created earlier,
build a consul stanza using it, and then append it to the nomad_config.hcl file.

```bash
cat <<EOF >> ~/nomad_config.hcl

consul {
  token = "$(awk '/SecretID/ {print $2}' nomad-agent.token)"
}
EOF
```{{execute}}

If you have the nomad_config.hcl file open in your editor, close and reopen the
`nomad_config.hcl`{{open}} file to see the results of the last command.

Nomad must be restarted to load the new configuration. Run the 
`systemctl restart nomad`{{execute}} command to restart Nomad and load these
changes.
