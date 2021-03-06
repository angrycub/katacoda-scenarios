#!/usr/bin/env bash

## Borrowed with many thanks from Ciro S. Costa
## "Using network namespaces and a virtual switch to isolate servers"
## https://ops.tips/blog/using-network-namespaces-and-bridge-to-isolate-servers/

ip link add name br1 type bridge
ip link set br1 up
ip addr add 192.168.1.10/24 brd + dev br1
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j MASQUERADE

mkdir -p $dir/opt/{consul,nomad}/server{1,2,3}/{data,logs}
mkdir -p $dir/opt/{consul,nomad}/client/{data,logs}

for I in {1..3}
do 
  ln -s /opt/nomad/server$I/nomad.hcl /root/nomad-server$I.hcl
  ln -s /opt/consul/server$I/consul.hcl /root/consul-server$I.hcl
done
ln -s /opt/nomad/client/nomad.hcl /root/nomad-client.hcl
ln -s /opt/consul/client/consul.hcl /root/consul-client.hcl

echo "Creating network environments..."

## Servers
for I in {1..3}
do
  echo " - server $I"
  ip netns add server$I
  ip link add veth$I type veth peer name br-veth$I
  ip link set veth$I netns server$I
  ip netns exec server$I ip addr add 192.168.1.1$I/24 dev veth$I
  ip link set br-veth$I up
  ip netns exec server$I ip link set lo up
  ip netns exec server$I ip link set veth$I up
  ip link set br-veth$I master br1
  ip netns exec server$I ip route add default via 192.168.1.10

  ## Config Stuff
  sed "s/{{NODE}}/server$I/g" /tmp/nomad.server.hcl.template > /opt/nomad/server$I/nomad.hcl
  sed "s/{{NODE}}/server$I/g" /tmp/consul.server.hcl.template > /opt/consul/server$I/consul.hcl
 
  cat << EOF > /usr/local/bin/server$I
#!/usr/bin/env bash

ip netns exec server$I /bin/bash --rcfile <(cat ~/.bashrc; echo "cd /opt/nomad/server$I"; echo 'PS1="\$(ip netns identify) > "')
EOF

  cat << EOF > /usr/local/bin/stop_server$I
#!/usr/bin/env bash

NOMAD_SERVER_PID=\$(ps aux | grep nomad | awk "/server$I/ {print \\\$2}")
CONSUL_SERVER_PID=\$(ps aux | grep consul | awk "/server$I/ {print \\\$2}")

if [ "\$NOMAD_SERVER_PID" != "" ]
then
  ip netns exec server$I kill \$NOMAD_SERVER_PID
  echo "Stopped Nomad PID \$NOMAD_SERVER_PID"
else
  echo "No running Nomad PID found for Server $I"
fi

if [ "\$CONSUL_SERVER_PID" != "" ]
then
  ip netns exec server$I kill \$CONSUL_SERVER_PID
  echo "Stopped Consul PID \$CONSUL_SERVER_PID"
else
  echo "No running Consul PID found for Server $I"
fi
EOF

  cat << EOF > /usr/local/bin/start_server$I
#!/usr/bin/env bash
echo -n "Starting server $I..."
ip netns exec server$I nohup consul agent -config-file=/opt/consul/server$I/consul.hcl >> /opt/consul/server$I/logs/consul.log 2>&1 </dev/null &

if [ "\$?" ]
then
  echo "Started Consul Server $I"
else
  echo "Received non-zero exit code (\$?) on start of Consul Server $I."
fi
ip netns exec server$I nohup nomad agent -config=/opt/nomad/server$I/nomad.hcl >> /opt/nomad/server$I/logs/nomad.log 2>&1 </dev/null &

if [ "\$?" ]
then
  echo "Started Nomad Server $I"
else
  echo "Received non-zero exit code (\$?) on start of Nomad Server $I."
fi
EOF

  cat << EOF > /usr/local/bin/restart_server$I
#!/usr/bin/env bash

stop_server$I
start_server$I
EOF

  chmod +x /usr/local/bin/*server*
  start_server$I

done

## client
## has to be the non-namespaced host because docker magic
echo " - client"

## Nomad Stuff
sed "s/{{NODE}}/client/g" /tmp/consul.client.hcl.template > /opt/consul/client/consul.hcl
sed "s/{{NODE}}/client/g" /tmp/nomad.client.hcl.template > /opt/nomad/client/nomad.hcl

cat << EOF > /usr/local/bin/stop_client
#!/usr/bin/env bash

NOMAD_CLIENT_PID=\$(ps aux | grep nomad | awk "/client/ {print \\\$2}")
CONSUL_CLIENT_PID=\$(ps aux | grep consul | awk "/client/ {print \\\$2}")

if [ "\$NOMAD_CLIENT_PID" != "" ]
then
  kill \$NOMAD_CLIENT_PID
  echo "Stopped Nomad PID \$NOMAD_CLIENT_PID"
else
  echo "No running Nomad PID found for client."
fi
if [ "\$CONSUL_CLIENT_PID" != "" ]
then
  kill \$CONSUL_CLIENT_PID
  echo "Stopped Consul PID \$CONSUL_CLIENT_PID"
else
  echo "No running Consul PID found for client."
fi
EOF

  cat << EOF > /usr/local/bin/start_client
#!/usr/bin/env bash
echo -n "Starting client..."
nohup consul agent -config-file=/opt/consul/client/consul.hcl >> /opt/consul/client/logs/consul.log 2>&1 </dev/null &
if [ "\$?" ]
then
  echo "Started client."
else
  echo "Received non-zero exit code (\$?) on start of consul client."
fi
nohup nomad agent -config=/opt/nomad/client/nomad.hcl >> /opt/nomad/client/logs/nomad.log 2>&1 </dev/null &
if [ "\$?" ]
then
  echo "Started client."
else
  echo "Received non-zero exit code (\$?) on start of Nomadclient."
fi
EOF

  cat << EOF > /usr/local/bin/restart_client
#!/usr/bin/env bash

stop_client
start_client
EOF

  chmod +x /usr/local/bin/*client*
  start_client

cat << EOF > /usr/local/bin/reset.sh
killall nomad
killall consul
for I in {1..3}
do
  ip link del br-veth\$I
  ip netns del server\$I
done
ip link del dev br1
iptables -t nat -D POSTROUTING -s 192.168.2.0/24 -j MASQUERADE
iptables -t nat -D POSTROUTING -s 192.168.1.0/24 -j MASQUERADE
EOF

chmod +x /usr/local/bin/reset.sh

echo "Finished."