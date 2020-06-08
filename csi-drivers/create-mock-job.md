This example uses a looping script, in the `config` stanza, to mock service
payloads.

Create a blank job file by running `touch mock-app.nomad`{{execute}}. Open
`mock-app.nomad`{{open}} in the editor and add this content.

<pre class="file" data-filename="mock-app.nomad" data-target="replace">job "mock-app" {
  datacenters = ["dc1"]
  type        = "service"

  group "mock-app" {
    # disable deployments
    update {
      max_parallel = 0
    }

    task "await-mock-service" {
      driver = "docker"

      config {
        image        = "busybox:1.28"
        command      = "sh"
        args         = ["-c", "echo -n 'Waiting for service'; until nslookup mock-service.service.consul 2>&1 >/dev/null; do echo '.'; sleep 2; done"]
        network_mode = "host"
      }

      resources {
        cpu    = 200
        memory = 128
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }
    }

    task "mock-app-container" {
      driver = "docker"

      config {
        image   = "busybox"
        command = "sh"
        args    = ["-c", "echo The app is running! && sleep 3600"]
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}
</pre>

The job contains two tasks—"await-mock-service" and "mock-app". The
"await-mock-service" task is configured to busy-wait until the "fake-cache"
service is advertised in Consul. For this guide, this will not happen until you
run the `fake-cache.nomad` job. In a more real-world case, this could be any
service dependency that advertises itself in Consul.

Note, since the "await-mock-service" task uses nslookup in a Docker
container, the job uses `network_mode = host`. In some cases,  you might need to
add the `dns_servers` value to the config stanza of the
"await-mock-service" task in the mock-app.nomad file to direct the query to a
DNS server that can receive queries on port 53 for your Consul DNS query root
domain.

You can use this pattern to model more complicated chains of service dependency
by including more await-style workloads.

