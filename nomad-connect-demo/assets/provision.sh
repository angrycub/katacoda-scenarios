#!/bin/bash

log() {
  echo $(date) - ${1}
}

fix_journal() {
  if [ ! -f "/etc/machine-id" ]; then
    log "Fixing Journal"
    systemd-machine-id-setup > /dev/null 2>&1
    systemd-tmpfiles --create --prefix /var/log/journal
    systemctl start systemd-journald.service
  fi
}

install_zip() {
  local NAME="${1}"
  if [ "${NAME}" == "" ]; then
    return
  fi
  log "Fetching zip and installing ${NAME}"
  if [ ! -f "/usr/local/bin/${NAME}" ]; then
    DOWNLOAD_URL="$2"
    curl -s -L -o /tmp/${NAME}.zip "${DOWNLOAD_URL}"
    sudo unzip -qq -d /usr/local/bin/ /tmp/${NAME}.zip
    sudo chmod +x /usr/local/bin/${NAME}
    rm /tmp/${NAME}.zip
  fi
}

install_services() {
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
  curl -s -L -o cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-amd64-v0.8.4.tgz
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
install_cni
install_pyhcl

install_zip "nomad" "https://releases.hashicorp.com/nomad/1.4.3/nomad_1.4.3_linux_amd64.zip"
install_zip "consul" "https://releases.hashicorp.com/consul/1.14.3/consul_1.14.3_linux_amd64.zip"

mkdir -p /etc/{consul,nomad}.d
mkdir -p /opt/{consul,nomad}/data
install_services

finish