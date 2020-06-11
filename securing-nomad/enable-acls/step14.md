With the app-dev token still active, export your cluster address into a variable
for convenience.

```shell
$ export NOMAD_ADDR=http://127.0.0.1:4646
```

Try to use the Nodes API to list out the Nomad clients in the cluster.

```shell
$ curl --header "X-Nomad-Token: ${NOMAD_TOKEN}" ${NOMAD_ADDR}/v1/nodes
Permission denied
```

Set the active token to your test prod-ops token.

```shell
$ export NOMAD_TOKEN=$(awk '/Secret/ {print $4}' prod-ops.token)
```

Resubmit your Nodes API query. Expect to have a significant amount of JSON
returned to your screen which indicates a successful API call.

```shell
$ curl --header "X-Nomad-Token: ${NOMAD_TOKEN}" ${NOMAD_ADDR}/v1/nodes
```
