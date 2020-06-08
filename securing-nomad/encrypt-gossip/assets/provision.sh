#! /bin/bash

log() {
  echo $(date) - ${1} | tee -a /var/log/provision.log
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

install_apt_deps() {
  log "Installing OS dependencies"
  export DEBIAN_FRONTEND=noninteractive
  apt-get -y update >> /var/log/provision.log 2>&1
  apt-get -y install sudo unzip daemon python3 python3-pip >> /var/log/provision.log 2>&1 
  unset DEBIAN_FRONTEND
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

install_pyhcl() {
  log "Installing pyhcl"
  pip install -qqq pyhcl
}

create_nomad_service() {
  if [ ! -f "/etc/nomad.d/nomad.hcl" ]
  then
    cp /tmp/nomad.hcl /etc/nomad.d/nomad.hcl
  fi
  cp /tmp/nomad.service /lib/systemd/system/
  systemctl enable nomad
}

finish() {
  touch /provision_complete
  log "Complete!  Move on to the next step."
}

# Main stuff
fix_journal
install_apt_deps
install_pyhcl

install_zip "nomad" "https://releases.hashicorp.com/nomad/0.11.2/nomad_0.11.2_linux_amd64.zip"

mkdir -p /etc/nomad.d
mkdir -p /opt/nomad/data

create_nomad_service
finish
