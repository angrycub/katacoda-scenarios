log() {
  echo $(date) - ${1}
}
maybeLog() {
  if [ ((loops % 10)) -eq 0 ]; then
    log "Waiting for /.scenario_data/bin/provision.sh"
  fi
}
loops=0
while [ ! -f /.scenario_data/bin/provision.sh ]; do
  sleep 0.5
  let "loops++"
  maybeLog
done
/.scenario_data/bin/provision.sh