log() {
  echo "$(date) - ${1}"
}

fail() {
  local reason="${1:-"fail called; exiting."}"
  log "${reason}"
  exit 1
}

maybeLog() {
  if [ $loops -gt 60 ]; then
    fail "Timed out waiting for /.scenario_data/bin/provision.sh"
  if [ ((loops % 10)) -eq 0 ]; then
    log "Waiting for /.scenario_data/bin/provision.sh"
  fi

}
log "background.sh started"
loops=0
while [ ! -x /.scenario_data/bin/provision.sh ]; do
  maybeLog
  sleep 0.5
  let "loops++"
done
log "Found /.scenario_data/bin/provision.sh; calling it"
/.scenario_data/bin/provision.sh
log "background.sh done"
