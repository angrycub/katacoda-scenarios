The ACL system uses a default-deny model. This means by default no permissions
are granted. For clients making requests without ACL tokens, you may want to
grant some basic level of access. This is done by setting rules on the special
"anonymous" policy. This policy is applied to any requests made without a token.

Create a file named `anonymous_policy.hcl`{{open}} with this HCL content:

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

This is an allow-all policy specification. You can use this as a transitional
anonymous policy, which will minimize time in which requests can not be
submitted to the cluster once you bootstrap.
