#!/bin/bash
CNI_VERSION=1.2.0
NOMAD_VERSION=1.4.3
CONSUL_VERSION=1.14.3

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

function defaultArch {
  local cpu=$(uname -m | sed 's/x86_64/amd64/')
  local os=$(uname -s | tr '[:upper:]' '[:lower:]')
  echo -n "${os}_${cpu}"
}

function fetch {
  local PRODUCT=${1}
  local VERSION=${2}
  local OSARCH=${4:-$(defaultArch)}

  echo "Fetching ${PRODUCT} v${VERSION} for ${OSARCH}..."
  URL="https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_${OSARCH}.zip"
  TMPDIR=`mktemp -d /tmp/fetch.XXXXXXXXXX` || (error "Unable to make temporary directory" ; exit 1)
  pushd ${TMPDIR} > /dev/null
  wget -q ${URL} -O ${PRODUCT}.zip
  unzip -q ${PRODUCT}.zip
  mv ${PRODUCT} /usr/local/bin
  popd > /dev/null
  rm -rf ${TMPDIR}
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
  curl -s -L -o cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-amd64-v1.0.0.tgz
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

fetch nomad "${NOMAD_VERSION}"
fetch consul "${CONSUL_VERSION}"

rsync --backup --suffix=old --verbose --archive /.scenario_data/etc/ /etc/
mkdir -p /opt/{consul,nomad}/data
install_services

finish