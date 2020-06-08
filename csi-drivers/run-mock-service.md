Run `nomad run mock-service.nomad`.

```shell
nomad run mock-service.nomad
```{{execute}}

Nomad will start the job and return information about the scheduling information.

```plaintext
$ nomad run mock-service.nomad
==> Monitoring evaluation "f31f8eb1"
    Evaluation triggered by job "mock-service"
    Allocation "d7767adf" created: node "f26809e6", group "mock-service"
    Evaluation within deployment: "3d86e09a"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "f31f8eb1" finished with status "complete"
```