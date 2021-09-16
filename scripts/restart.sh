#!/bin/bash --login
# Usage ./restart.sh <service name>

source config.sh
source init-common.sh

service=$1	  

if [[ -z ${service} ]]; then
	echo "Usage: ./restart.sh <service name>"
else
	echo "Restarting $service..."
	stop_svc_in_tmux ${service}
	start_svc_in_tmux ${service}
fi

