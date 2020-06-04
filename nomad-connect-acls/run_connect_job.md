<style type="text/css">
  .lang-screenshot { -webkit-touch-callout: none; -webkit-user-select: none; -khtml-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; }
  .alert { position: relative; padding: .75rem 1.25rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: .25rem; }
  .alert-info    { color: #0c5460; background-color: #d1ecf1; border-color: #bee5eb; }
</style>

Run `touch countdash.nomad`{{execute}} to create a blank job file.

Open `countdash.nomad`{{open}} in the editor and copy-and-paste this job
specification into the file.

<pre class="file" data-filename="countdash.nomad" data-target="replace">job "countdash" {
   datacenters = ["dc1"]
   group "api" {
     network {
       mode = "bridge"
     }

     service {
       name = "count-api"
       port = "9001"

       connect {
         sidecar_service {}
       }
     }

     task "web" {
       driver = "docker"
       config {
         image = "hashicorpnomad/counter-api:v1"
       }
     }
   }

   group "dashboard" {
     network {
       mode ="bridge"
       port "http" {
         static = 9002
         to     = 9002
       }
     }

     service {
       name = "count-dashboard"
       port = "9002"

       connect {
         sidecar_service {
           proxy {
             upstreams {
               destination_name = "count-api"
               local_bind_port = 8080
             }
           }
         }
       }
     }

     task "dashboard" {
       driver = "docker"
       env {
         COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
       }
       config {
         image = "hashicorpnomad/counter-dashboard:v1"
       }
     }
   }
 }
</pre>

### Create the intention

Consul service mesh starts in "default-deny" mode in datacenters that have ACLs enabled.
You must create an intention to allow traffic from the count-dashboard
service to the count-api service.

Run `consul intention create count-dashboard count-api`{{execute}}

**Example Output**

```screenshot
$ consul intention create count-dashboard count-api
Created: count-dashboard => count-api (allow)
```

### Run the job

Run the job by executing `nomad run countdash.nomad`{{execute}}.

**Example Output**

```screenshot
$ nomad run countdash.nomad
==> Monitoring evaluation "3e7ebb57"
    Evaluation triggered by job "countdash"
    Evaluation within deployment: "9eaf6878"
    Allocation "012eb94f" created: node "c0e8c600", group "api"
    Allocation "02c3a696" created: node "c0e8c600", group "dashboard"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "3e7ebb57" finished with status "complete"
```

Open the Countdash interface by clicking the "Countdash UI" tab above the
terminal. The Countdash interface may appear "Disconnected" on initial load.
Waiting a few seconds or refreshing your browser will update the status to
"Connected".

<div class="alert-info alert">
If the Countdash UI displays "Counting Service is Unreachaable",you should
go back and verify your configuration, and ensure that you have executed all
the guide commands—specifically the **consul intention create...** command.
</div>

Once you are done, run `nomad stop countdash`{{execute}} to prepare for the next
step.

**Example Output**

```screenshot
$ nomad stop countdash
==> Monitoring evaluation "d4796df1"
    Evaluation triggered by job "countdash"
    Evaluation within deployment: "18b25bb6"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "d4796df1" finished with status "complete"
```

