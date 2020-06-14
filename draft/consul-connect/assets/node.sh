#!/usr/bin/env bash

# node - build a network namespace for a "node" given an
# ip address and a node id
function usage () {
  local l_MSG=$1
  echo "Usage Error: $l_MSG"
  echo "Usage: ${SCRIPT}"
  echo "Required command line arguments"
  echo "-i <string> -- name for node/netns"
  echo "-b <string> -- specifies the bridge to attach to."
  echo "-a <string> -- node's ip address.  Must include CIDR e.g. 192.168.1.11/24"
  echo "-g <string> -- gateway IP address for connection"
  exit 1
}

#If an option should be followed by an argument, it should be followed by a ":".
#The leading ":" suppresses error messages from
#getopts. This is required to get my unrecognized option code to work.
let FLAGS=0
while getopts :n:g:b:a: FLAG; do
  case $FLAG in
    g) # set option "p" specifying the product
      GATEWAY_ADDRESS=$OPTARG
      FLAGS=$((FLAGS+1))
      ;;
    b) # set option "v"
      BRIDGE_NAME=$OPTARG
      FLAGS=$((FLAGS+1))
      ;;
    a) # set option "a"
      NODE_ADDRESS=$OPTARG
      FLAGS=$((FLAGS+1))
      ;;
    n) # set option "n"
      NODE_ID=$OPTARG
      FLAGS=$((FLAGS+1))
      ;;
    *) # invalid command line arguments
      usage "Invalid command line argument $OPTARG"
      ;;
  esac
done  

NUMARGS=$#
if [ $NUMARGS -eq 0 ]; then
  usage 'No command line arguments specified'
fi

if [ ! $FLAGS -eq 4 ]; then
  usage 'Incorrect number of arguments specified'
fi

INSTALL_PATH="/usr/local/bin"

ip netns add ${NODE_ID}
ip link add veth0 type veth peer name ${NODE_ID}-veth0
ip link set veth0 netns ${NODE_ID}

# Bring up the bridge side interfaces
ip link set ${NODE_ID}-veth0 master ${BRIDGE_NAME}
ip link set ${NODE_ID}-veth0 up

# Bring up the namespace side interfaces
ip netns exec ${NODE_ID} ip link set lo up
ip netns exec ${NODE_ID} ip link set veth0 up

# Add IP address
ip netns exec ${NODE_ID} ip addr add ${NODE_ADDRESS} dev veth0
ip netns exec ${NODE_ID} ip route add default via ${GATEWAY_ADDRESS}


cat << EOF > ${INSTALL_PATH}/delete-${NODE_ID}.sh
ip netns exec ${NODE_ID} ip route del default via ${GATEWAY_ADDRESS}
ip netns exec ${NODE_ID} ip addr del ${NODE_ADDRESS} dev veth0
ip netns exec ${NODE_ID} ip link set lo down
ip netns exec ${NODE_ID} ip link set veth0 down
ip link set ${NODE_ID}-veth0 down
ip link del dev ${NODE_ID}-veth0 type veth
ip netns del ${NODE_ID}
echo "Done."
EOF

chmod +x ${INSTALL_PATH}/reset.sh
