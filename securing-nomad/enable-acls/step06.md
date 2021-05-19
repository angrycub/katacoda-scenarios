The ACL system uses a default-deny model. This means by default, Nomad doesn't
grant any permissions for requests made by non-management tokens. For clients
making requests without ACL tokens, you may want to grant some basic level of
access. This is done by setting rules on the special “anonymous” policy. Nomad
applies this policy to any requests made without a token.

In this hands-on lab, you will create an “allow-all” anonymous policy
specification. This illustrates how you might create a transitional anonymous
policy. Apply this policy to restore the cluster to a default-allow state, which
will shorten the time in which requests can not be submitted to the cluster
without a token.

Create a file named `anonymous_policy.hcl`{{open}} with this HCL content:

<!-- markdownlint-disable no-inline-html -->
<pre class="file" data-filename="anonymous_policy.hcl" data-target="replace">
namespace "*" {
  policy       = "write"
  capabilities = ["alloc-node-exec"]
}

agent {
  policy = "write"
}

operator {
  policy = "write"
}

quota {
  policy = "write"
}

node {
  policy = "write"
}

host_volume "*" {
  policy = "write"
}

plugin {
  policy = "read"
}
</pre>
<!-- markdownlint-restore -->
