#!/usr/bin/env sh

IP_ADDRS=(
  '192.168.178.51'
  # Add lines here if you have multiple lights.
)

# To use pre-set values, see below.
BRIGHTNESS=40
TEMPERATURE=162

switch() {
  STR="on"
  if [ $1 -eq 0 ]; then
    STR="off"
  fi

  for addr in "${IP_ADDRS[@]}"
  do
    ADDR="http://${addr}:9123/elgato/lights"
    echo ""
    echo "Switching $STR light at "$ADDR

    # Default is using the settings from before.
    SETTINGS='{"lights":[{"on":'"$1"'}]}'
    # Use the line below to always turn on with specified settings.
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

STATUS=0

log stream --predicate 'subsystem == "com.apple.cmio" and (composedMessage contains "stream")' | while read line; do
  if [ $STATUS -eq 0 ]; then
    if echo "$line" | grep -q -i "start"; then
      STATUS=1
      switch_on
    fi
  fi

  if [ $STATUS -eq 1 ]; then
    if echo "$line" | grep -q -i "stop"; then
      STATUS=0
      switch_off
    fi
  fi

done