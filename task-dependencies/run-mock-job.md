Run `nomad run mock-app.nomad`.  

```shell
nomad run mock-app.nomad
```{{execute}}

The job will launch and provide you an allocation ID in the output.

```plaintext
$ nomad run mock-app.nomad
==> Monitoring evaluation "01c73d5a"
    Evaluation triggered by job "mock-app"
    Allocation "3044dda0" created: node "f26809e6", group "mock-app"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "01c73d5a" finished with status "complete"
```