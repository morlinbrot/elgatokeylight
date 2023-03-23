#!/usr/bin/env sh

IP_ADDRS=(
  '192.168.178.51'
  # Add lines here if you have multiple lights.
)

# To use pre-set values, see below.
BRIGHTNESS=40
TEMPERATURE=162

switch() {
  for addr in "${IP_ADDRS[@]}"
  do
    ADDR="http://${addr}:9123/elgato/lights"
    echo "Switching on light at "$ADDR

    SETTINGS='{"lights":[{"on":'"$1"'}]}'
    # Use this to always turn on with the settings above.
    # SETTINGS='{"lights":[{"brightness":'"${BRIGHTNESS}"',"temperature":'"${TEMPERATURE}"',"on":'"$1"'}],"numberOfLights":1}'

    curl --location --request PUT $ADDR --header 'Content-Type: application/json' --data-raw $SETTINGS
  done
}

switch_on() {
  switch 1
}

switch_off() {
  switch 0
}


# Begin looking at the system log via the steam sub-command. Using a --predicate and filtering by the correct and pull out the camera event 
log stream --predicate 'subsystem == "com.apple.UVCExtension" and composedMessage contains "Post PowerLog"' | while read line; do
  
  # The camera start event has been caught and is set to 'On', turn the light on
  if echo "$line" | grep -q "= On"; then
  	echo "Camera has been activated, turn on the light."
    switch_on
  fi

  # If we catch a camera stop event, turn the light off.
  if echo "$line" | grep -q "= Off"; then
    echo
  	echo "Camera shut down, turn off the light."
  	switch_off
  fi
done