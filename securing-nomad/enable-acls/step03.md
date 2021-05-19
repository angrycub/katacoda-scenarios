<!-- markdownlint-disable first-line-h1 -->

The APIs needed to manage policies and tokens are not enabled until ACLs are
enabled. To begin, you need to enable the ACLs on the servers. If your cluster
is a multi-region setup, you should enable ACLs on the authoritative region
first.

To enable ACLs, set the enabled value of the `acl` stanza to true. The `acl`
stanza is a top-level stanza.

```screenshot
acl {
  enabled = true
}
```

## Configure server nodes

Add the `acl` stanza to each of your server configurations.

### Configure server1

Start by opening `server1.hcl`{{open}} in the editor. Add the `acl` stanza.

<pre class="file" data-filename="server1.hcl" data-target="append">
acl {
  enabled = true
}
</pre>

### Configure server2

Open `server2.hcl`{{open}} in the editor, and add the `acl` stanza.

<pre class="file" data-filename="server2.hcl" data-target="append">
acl {
  enabled = true
}
</pre>

## Configure server3

Open `server3.hcl`{{open}} in the editor, and add the `acl` stanza.

<pre class="file" data-filename="server3.hcl" data-target="append">
acl {
  enabled = true
}
</pre>

## Configure client nodes

Nomad client nodes must also be configured with the ACL stanza.

### Configure client

Open `client.hcl`{{open}} in the editor, and add the `acl` stanza.

<pre class="file" data-filename="client.hcl" data-target="append">
acl {
  enabled = true
}
</pre>
