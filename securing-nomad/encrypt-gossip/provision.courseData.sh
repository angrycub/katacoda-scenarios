cat << 'EOFSRSLY' > /tmp/provision.sh
#! /bin/bash

log() {
  echo $(date) - ${1}
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

create_nomad_service() {
  log "Creating Nomad Service"
  if [ ! -f /etc/nomad.d/config.hcl ]
  then
    cat > /etc/nomad.d/config.hcl <<EOF
  data_dir  = "/opt/nomad/data"
  log_level = "DEBUG"

  client {
    enabled = true
  }

  plugin "raw_exec" {
    config {
      enabled = true
    }
  }

  server {
    enabled          = true
    bootstrap_expect = 1
  }
EOF

  fi

  ln -s /etc/nomad.d/config.hcl ~/nomad_config.hcl
}

install_pyhcl() {
  log "Installing pyhcl..."
  pip install -qqq pyhcl
}

finish() {
  touch /provision_complete
  log "Complete!  Move on to the next step."
}

install_apt_deps {
  apt update
  apt install sudo unzip daemon
}

# Main stuff
install_apt_deps
install_pyhcl

install_zip "nomad" "https://releases.hashicorp.com/nomad/0.11.2/nomad_0.11.2_linux_amd64.zip"

mkdir -p /etc/nomad.d
mkdir -p /opt/nomad/data

create_nomad_service
finish

EOFSRSLY

chmod +x /tmp/provision.sh
