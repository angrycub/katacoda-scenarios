#!/bin/bash

spin()
{
  spinner_dots_ccw="⣾⣽⣻⢿⡿⣟⣯⣷"
  spinner_dots_cw="⣷⣯⣟⡿⢿⣻⣽⣾"
  spinner="/|\\-/|\\-"
  while :
  do
    for i in `seq 0 7`
    do
      printf "${spinner_dots_cw:$i:1} Waiting for provisioning to complete...\r"
      sleep .5
      printf "\r"
    done
  done
}

# Start the Spinner:
spin &
# Make a note of its Process ID (PID):
SPIN_PID=$!
# Kill the spinner on any signal, including our own exit.
trap "kill -9 $SPIN_PID" `seq 0 15`

while [ ! -f /provision_complete ]; do
  sleep 0.2
done

printf "\nFinished.\n"

# If the script is going to exit here, there is nothing to do.
# The trap above will kill the spinner when this script exits.
# Otherwise, if the script is going to do more stuff, you can
# kill the spinner now:
kill -9 $SPIN_PID