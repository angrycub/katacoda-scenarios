Run the `nomad alloc status` command with the provided allocation ID.

This command will load the proper id into an environment variable called ALLOC_ID for convenience.

```shell
export ALLOC_ID=$(curl -s localhost:4646/v1/job/mock-app/allocations | jq -r .[].ID)
```{{execute}}

Now, run `nomad alloc status`.

```shell
nomad alloc status ${ALLOC_ID}
```{{execute}}

You will receive a lot of information back. For this guide, focus on the status
of each task. Each task's status is output in lines that look like this

```plaintext
Task "await-mock-service" is "running"
```

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
Created             = 43s ago
Modified            = 42s ago

Task "await-mock-service" is "running"
Task Resources
CPU        Memory          Disk     Addresses
3/200 MHz  80 KiB/128 MiB  300 MiB  

Task Events:
Started At     = 2020-03-18T17:07:26Z
Finished At    = N/A
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type        Description
2020-03-18T13:07:26-04:00  Started     Task started by client
2020-03-18T13:07:26-04:00  Task Setup  Building Task Directory
2020-03-18T13:07:26-04:00  Received    Task received by client

Task "mock-app-container" is "pending"
Task Resources
CPU      Memory   Disk     Addresses
200 MHz  128 MiB  300 MiB  

Task Events:
Started At     = N/A
Finished At    = N/A
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type      Description
2020-03-18T13:07:26-04:00  Received  Task received by client
```

Notice that the await-mock-service task is running and that the
"mock-app-container" task is pending. The "mock-app-container" task will remain
in pending until the "await-mock-service" task completes successfully.
