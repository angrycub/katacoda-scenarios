Create a blank job file by running `touch mock-service.nomad`{{execute}}. Open
`mock-service.nomad`{{open}} in the editor and add this content.

<pre class="file" data-filename="mock-service.nomad" data-target="replace">
job "mock-service" {
  datacenters = ["dc1"]
  type        = "service"

  group "mock-service" {
    task "mock-service" {
      driver = "docker"

      config {
        image   = "busybox"
        command = "sh"
        args    = ["-c", "echo The service is running! && while true; do sleep 2; done"]
      }

      resources {
        cpu    = 200
        memory = 128
      }

      service {
        name = "mock-service"
      }
    }
  }
}
</pre>

This job advertises the "mock-service" service in Consul. When run, this
will allow the await-mock-service task to complete successfully and let
the "mock-app-container" task start up.
