#!/bin/bash

[ $# -le 2 ] || exit

OPTIONS=( "migrate" "clean" "info" "validate" "undo" "baseline" "repair" )
ENVIRONMENTS=("test" "dev" "prod")

OPTION_ENV=test
OPTION_FLYWAY=info
RUN=0

options_env() {
  echo "Options: [ ${ENVIRONMENTS[*]} ]"
}

if [ -z "$2" ]; then
  echo "No argument supplied. Default environment: dev"
  options_env
else
  for i in "${ENVIRONMENTS[@]}"; do
    if [ "$i" == "$2" ] ; then
      OPTION_ENV=$2
    fi
  done
fi

options() {
  echo "Options: [ ${OPTIONS[*]} ]"
}

if [ -z "$1" ]; then
  echo "No argument supplied. Default: info"
  options
  RUN=1
else
  for i in "${OPTIONS[@]}"; do
    if [ "$i" == "$1" ] ; then

      OPTION_FLYWAY=$1
      RUN=1
    fi
  done
fi

export FLYWAY_CONFIG_FILES=./conf/$OPTION_ENV.conf
export FLYWAY_LOCATIONS=filesystem:./sql/$OPTION_ENV

if [ $RUN == 1 ]; then
  echo "Exec: $OPTION_FLYWAY"
  #exec flyway -configFiles="$FLYWAY_CONFIG_FILES" -locations="$FLYWAY_LOCATIONS" $OPTION_FLYWAY
  exec flyway $OPTION_FLYWAY
else
  echo "Not found command: $1"
  options
  exit
fi




#
