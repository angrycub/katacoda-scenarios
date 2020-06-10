The APIs needed to manage policies and tokens are not enabled until ACLs are
enabled. To begin, you need to enable the ACLs on the servers. If a multi-region
setup is used, the authoritative region should be enabled first.

To enable ACLs, set the enabled value of the `acl` stanza to true. The `acl` 
stanza is a top-level stanza.

```
acl {
  enabled = true
}
```

## Configure server1

Switch to server1 namespace.

```
server1
```{{execute}}

Edit the nomad.hcl file with vim (or nano if you prefer).

```
vim nomad.hcl
```{{execute}}

Add the token. This guide will use a the token `cg8StVXbQJ0gPvMd9o7yrg==`

If you are using nano, scroll to the endIf you are using vim, type the following commands into vim to navigate to the
bottom of the file:

`G`{{execute}},
`i`{{execute}}.

Add the acl stanza token

```
acl {
  enabled = true
}
```{{execute}}

Save and exit vim with the following command

```
:wq
```{{execute interrupt}}

Exit the server1 namespace.

```
exit
```{{execute}}

Repeat this process for the server2 and server3 namespaces.

You can run this command and the scenario will do it for you.

```
finish_step2.sh
```{{execute}}
