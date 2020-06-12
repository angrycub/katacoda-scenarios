#! /bin/bash

log() {
  echo $(date) - ${1}
}

fix_journal() {
  log "Fixing Journal"
  if [ ! -f "/etc/machine-id" ]
  then
    systemd-machine-id-setup > /dev/null 2>&1
    systemd-tmpfiles --create --prefix /var/log/journal
    systemctl start systemd-journald.service
  fi
}

install_dnsmasq() {
  log "Installing dnsmasq"
  sudo apt-get -q -y -o Dpkg::Use-Pty=0 install dnsmasq > /dev/null
  cat > /etc/dnsmasq.d/10-consul << EOF
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600

# Uncomment and modify as appropriate to enable reverse DNS lookups for
# common netblocks found in RFC 1918, 5735, and 6598:
#rev-server=0.0.0.0/8,127.0.0.1#8600
#rev-server=10.0.0.0/8,127.0.0.1#8600
#rev-server=100.64.0.0/10,127.0.0.1#8600
#rev-server=127.0.0.1/8,127.0.0.1#8600
#rev-server=169.254.0.0/16,127.0.0.1#8600
#rev-server=172.16.0.0/12,127.0.0.1#8600
#rev-server=192.168.0.0/16,127.0.0.1#8600
#rev-server=224.0.0.0/4,127.0.0.1#8600
#rev-server=240.0.0.0/4,127.0.0.1#8600
EOF

  systemctl restart dnsmasq
}


install_zip() {
  NAME="$1"
  log "Fetching zip and installing ${NAME}"
  if [ ! -f "/usr/local/bin/$NAME" ]
  then
    DOWNLOAD_URL="$2"
    curl -s -L -o /tmp/$NAME.zip $DOWNLOAD_URL
    sudo unzip -qq -d /usr/local/bin/ /tmp/$NAME.zip
    sudo chmod +x /usr/local/bin/$NAME
    rm /tmp/$NAME.zip
  fi
}



install_services() {

  ln -s /etc/consul.d/consul.hcl ~/consul_config.hcl
  ln -s /etc/nomad.d/nomad.hcl ~/nomad_config.hcl

  systemctl daemon-reload
  systemctl enable consul --quiet
  systemctl enable nomad --quiet
  systemctl start consul
  systemctl start nomad
}

install_pyhcl() {
  log "Installing pyhcl..."
  pip install -qqq pyhcl
}

install_cni() {
  log "Installing CNI Plugins..."
  curl -s -L -o cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v0.8.4/cni-plugins-linux-amd64-v0.8.4.tgz
  sudo mkdir -p /opt/cni/bin
  sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz
  rm cni-plugins.tgz
}

finish() {
  touch /provision_complete
  log "Complete!  Move on to the next step."
}

# Main stuff

fix_journal
install_dnsmasq
install_cni
install_pyhcl

install_zip "nomad" "https://releases.hashicorp.com/nomad/0.11.0-beta1/nomad_0.11.0-beta1_linux_amd64.zip"
install_zip "consul" "https://releases.hashicorp.com/consul/1.7.2/consul_1.7.2_linux_amd64.zip"

mkdir -p /etc/nomad.d /etc/consul.d
mkdir -p /opt/nomad/data /opt/consul/data

install_services

finish