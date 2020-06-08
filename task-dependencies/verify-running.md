Finally, check the output of the `nomad alloc status` command again to check the
task statuses. Use the allocation ID from when you ran the "mock-app" job.

```shell
export ALLOC_ID=$(curl -s localhost:4646/v1/job/mock-app/allocations | jq -r .[].ID)
```{{execute}}

```shell
nomad alloc status ${ALLOC_ID}
```{{execute}}

Again, focus on the task status lines for "await-mock-service" and "mock-app-container".

```plaintext
$ nomad alloc status ${ALLOC_ID}
ID                  = 3044dda0-8dc1-1bac-86ea-66a3557c67d3
Eval ID             = 01c73d5a
Name                = mock-app.mock-app[0]
Node ID             = f26809e6
Node Name           = nomad-client-2.node.consul
Job ID              = mock-app
Job Version         = 0
Client Status       = running
Client Description  = Tasks are running
Desired Status      = run
Desired Description = <none>
Created             = 21m38s ago
Modified            = 7m27s ago

Task "await-mock-service" is "dead"
Task Resources
CPU        Memory          Disk     Addresses
0/200 MHz  80 KiB/128 MiB  300 MiB  

Task Events:
Started At     = 2020-03-18T17:07:26Z
Finished At    = 2020-03-18T17:21:35Z
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type        Description
2020-03-18T13:21:35-04:00  Terminated  Exit Code: 0
2020-03-18T13:07:26-04:00  Started     Task started by client
2020-03-18T13:07:26-04:00  Task Setup  Building Task Directory
2020-03-18T13:07:26-04:00  Received    Task received by client

Task "mock-app-container" is "running"
Task Resources
CPU        Memory          Disk     Addresses
0/200 MHz  32 KiB/128 MiB  300 MiB  

Task Events:
Started At     = 2020-03-18T17:21:37Z
Finished At    = N/A
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type        Description
2020-03-18T13:21:37-04:00  Started     Task started by client
2020-03-18T13:21:35-04:00  Driver      Downloading image
2020-03-18T13:21:35-04:00  Task Setup  Building Task Directory
2020-03-18T13:07:26-04:00  Received    Task received by client
```

Notice, the "await-mock-service" task is dead and based on the "Recent Events"
table terminated with "Exit Code: 0". This indicates that it completed
successfully. The "mock-app-container" task has now transitioned to the
"running" status and the container is running.
