Out of the box, Nomad's gossip encryption is unencrypted. This allows
a listener to observe the cluster membership information and even to
join the cluster. Encrypting the Serf protocol traffic will help to
ensure that only the expected nodes will participate in your cluster.

Gossip encryption also helps to prevent accidental federation of
Nomad clusters when they are using the Consul auto-join feature.

You can observe this unencrypted traffic by running tcpdump to
capture UDP traffic on the Serf port-4648.

```
tcpdump 'udp port 4648' -A
```

If you watch long enough, you will see traffic that shows clear
elements of traffic like the member's node name.
