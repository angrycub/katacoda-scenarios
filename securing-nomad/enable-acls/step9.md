In this guide, you will create Nomad ACL policies to provide controlled
access for two different personas to your Nomad Cluster. You will use the sample
job created with the `nomad init -short` command as a sample job.

## Meet the personas

In this guide, you will create policies to manage cluster access for two
different user personas. These are contrived to suit the scenario, and
you should design your ACL policies around your organization's specific needs.

As a best practice, access should be limited as much as possible given the needs
of the user's roles.

### Application Developer

The application developer needs to be able to deploy an application into the
Nomad cluster and control its lifecycle. They should not be able to perform any
other node operations.

Application developers are allowed to fetch logs from their running containers,
but should not be allowed to run commands inside of them or access the 
filesystem for running workloads.

### Production Operations

The production operations team needs to be able to perform cluster
maintenance and view the workload, including attached resources like
volumes, in the running cluster. However, because the application
developers are the owners of the running workload, the production
operators should not be allowed to run or stop jobs in the cluster.