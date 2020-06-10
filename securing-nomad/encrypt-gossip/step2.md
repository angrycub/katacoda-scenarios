Open your nomad configuration files.

Switch to server1 namespace.

```
server1
```{{execute}}

Edit the nomad.hcl file with vi (or nano if you prefer).

```
vim nomad.hcl
```{{execute}}

Add the token. This guide will use a the token `cg8StVXbQJ0gPvMd9o7yrg==`

Type the following commands into vim to add the token:

`/server {`{{execute}},
`j`{{execute}},
`i`{{execute}}.

Add the encryption token

```
  # Encrypt gossip communication
  encrypt = "cg8StVXbQJ0gPvMd9o7yrg=="
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
finish_config.sh
```{{execute}}
