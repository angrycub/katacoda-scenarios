while [ ! -x /usr/local/bin/provision.sh ]; do sleep 1; done; /usr/local/bin/provision.sh
export NOMAD_ADDR=http://192.168.1.11:4646
