#!/usr/bin/env bash

## Borrowed with many thanks from Ciro S. Costa
## "Using network namespaces and a virtual switch to isolate servers"
## https://ops.tips/blog/using-network-namespaces-and-bridge-to-isolate-servers/

# BRIDGE_NAME ("br1") - 
# NETWORK_COUNT (1) -
INSTALL_PATH="/usr/local/bin"
BN=${BRIDGE_NAME:="br1"}

echo "Building bridge ${BN}"
ip link add name ${BN} type bridge
ip link set ${BN} up

# Build a user specifyable number of networks

NC=${NETWORK_COUNT:=1}
for NI in $(seq $NC)
do
  echo "- Creating 192.168.${NI}.0/24..."
  ip addr add 192.168.${NI}.1/24 brd + dev ${BN}
  iptables -t nat -A POSTROUTING -s 192.168.${NI}.0/24 -j MASQUERADE
done

cat << EOF > /usr/local/bin/reset.sh
echo "Removing Networks..."
for NI in \$(seq $NC)
do
  echo "- Removing 192.168.\${NI}.0/24..."
  iptables -t nat -D POSTROUTING -s 192.168.\${NI}.0/24 -j MASQUERADE
  ip addr del 192.168.\${NI}.1/24 brd + dev ${BN}
done

echo "Removing Bridge ${BN}..."
ip link set ${BN} down
ip link del dev ${BN} type bridge

echo "Done."
EOF

chmod +x ${INSTALL_PATH}/reset.sh
