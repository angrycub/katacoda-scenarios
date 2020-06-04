<style type="text/css">
.lang-screenshot { -webkit-touch-callout: none; -webkit-user-select: none; -khtml-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; }
</style>

Open the `nomad_config.hcl`{{open}} file, and add a consul stanza with your token.

```hcl
consul {
  token = "«your nomad agent token»"
}
```

If you want to automate this process, the following command is an example of how you
could inject the Nomad agent token created in the previous step.

```bash
cat <<EOF >> ~/nomad_config.hcl

consul {
  token = "$(awk '/SecretID/ {print $2}' nomad-agent.token)"
}
EOF
```{{execute}}

Close and reopen the `nomad_config.hcl`{{open}} file to see the results of the last command.

Nomad must be restarted to load the new congiguration. Run the `systemctl restart nomad`{{execute}}
command to restart Nomad and load these changes.
