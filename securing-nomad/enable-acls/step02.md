<!-- markdownlint-disable first-line-h1 -->

The ACL system is designed to be intuitive, high-performance, and to provide
administrative insight. At the highest level, there are four core objects used
in the ACL system.

- Tokens
- Policies
  - Rules
- Capabilities

## Core objects overview

- **Tokens** — Nomad authenticates requests based on a bearer token.
  Each ACL token has a public accessor ID which names the token and a
  Secret ID which is used to make requests to Nomad. Users provide the Secret ID
  using the `X-Nomad-Token` request header. Nomad then authenticates the caller
  based on the provided token. Tokens are either `management` or `client` types.
  The `management` tokens are effectively “root” in the system and can perform
  any operation. Client tokens have one or more ACL policies attached to them
  that grant specific capabilities.

- **Policies** — Policies consist of a set of rules defining the capabilities or
  actions to be granted. For example, a “read-only” policy might only grant the
  ability to list and inspect running jobs, but not to submit new ones. Nomad is
  a default-deny system, so it grants no permissions by default.

  - **Rules** — Policies contain of one or more rules. The rules define
    the capabilities of a Nomad ACL token for accessing objects in a Nomad
    cluster—like namespaces, node, agent, operator, quota. A later section
    discusses the full set of rules.

- **Capabilities** — Capabilities are the set of actions that can be performed.
  This includes listing jobs, submitting jobs, querying nodes, etc. A
  `management` token has all capabilities, while a `client` tokens associated
  ACL policies determine the specific capabilities granted it. The “Rule
  specifications” section discusses full set of capabilities.
