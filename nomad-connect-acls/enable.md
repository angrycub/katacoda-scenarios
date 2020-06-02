<style type="text/css">
.alert { position: relative; padding: .75rem 1.25rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: .25rem; }
.alert-dark    { color: #1b1e21; background-color: #d6d8d9; border-color: #c6c8ca; }
.alert-primary { color: #004085; background-color: #cce5ff; border-color: #b8daff; }
.alert-info    { color: #0c5460; background-color: #d1ecf1; border-color: #bee5eb; }
.alert-warning { color: #856404; background-color: #fff3cd; border-color: #ffeeba; }
.alert-danger  { color: #721c24; background-color: #f8d7da; border-color: #f5c6cb; }
.noselect {
  -webkit-touch-callout: none; /* iOS Safari */
    -webkit-user-select: none; /* Safari */
     -khtml-user-select: none; /* Konqueror HTML */
       -moz-user-select: none; /* Old versions of Firefox */
        -ms-user-select: none; /* Internet Explorer/Edge */
            user-select: none; /* Non-prefixed version, currently
                                  supported by Chrome, Opera and Firefox */
}
</style>

### Enable ACLs in Consul configuration

Open the `consul_config.hcl`{{open}} file and add this stanza anywhere in the
top level.

<pre class="file" data-target="clipboard">
acl {
  enabled                  = true
  default_policy           = "deny"
  enable_token_persistence = true
}
</pre>

### Restart Consul

Run `systemctl restart consul`{{execute}} to restart Consul to load
these changes.

### Bootstrap Consul ACLs

Next, bootstrap the Consul ACL subsystem. Run
`consul acl bootstrap | tee consul.bootstrap`{{execute}}
to bootstrap the ACL system, generate your first token, and capture the output
into the `consul.bootstrap` file.

<div class="alert-info alert">
If you receive an error saying "The ACL system is currently in legacy mode.",
this indicates that the Consul service is still starting. Wait a few seconds and
try the command again.
</div>

**Example Output**

```screenshot
$ consul acl bootstrap | tee consul.bootstrap
AccessorID:       e57b446b-2da0-bce2-f01c-6c0134d8e19b
SecretID:         bba19e7c-9f47-2b08-f0ea-e1bca43ba9c5
Description:      Bootstrap Token (Global Management)
Local:            false
Create Time:      2020-02-20 17:01:13.105174927 +0000 UTC
Policies:
   00000000-0000-0000-0000-000000000001 - global-management
```

Next, we will create a Consul agent ACL policy and a token for use on the Consul
agent.
