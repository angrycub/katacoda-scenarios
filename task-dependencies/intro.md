# Modeling Inter-Service Dependencies using Nomad Task Dependencies

Nomad task dependencies provide the ability to define init-style tasks. These
tasks can model complex job dependency trees by delaying the job's main tasks
from running until a condition is met. In this case, until a service is
available and advertised in Consul.

In Nomad, you model init-style tasks as non-sidecar tasks connected to the
prestart lifecycle hook. Tasks that hook prestart and are not `sidecar` tasks
are expected to complete successfully before Nomad will run the main tasks in
the job.

In this guide, you will deploy two jobs with Nomad. In the job file for the
dependent service, "mock-app", you will configure a task to monitor for the
existence of the required service, "mock-service". You will test the dependency
by deploying the dependent service first.
