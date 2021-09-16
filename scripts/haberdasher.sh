#!/usr/bin/env bash

source config.sh

# Enable haberdasher
export LOG_HANDLER=haberdasher

if [[ $# -gt 3 ]] | [[ $# -lt 2 ]]; then
  echo "Illegal number of parameters."
  exit 2
fi

if [ $2 != "kafka" ] && [ $2 != "stderr" ]; then
  echo "Second parameter have to be kafka or stderr."
  exit 2
fi

if [[ $2 == "kafka" ]]; then
  HABERDASHER_EMITTER=$HABERDASHER_KAFKA_EMITTER
fi

if [[ ! -z $3 ]] && [[ $3 != "without_hb" ]]; then
  echo "The only allowed value for third parameter is without_hb"
  exit 2
fi

if [[ $3 == "without_hb" ]]; then
  $1
else
  $HABERDASHER_PATH $1
fi


