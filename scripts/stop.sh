#!/bin/bash --login
# Usage ./stop.sh [service_name]

source config.sh
source ./init-common.sh

requested_svc=$1



if [[ -z ${requested_svc} ]]; then
    ./services/kafka.sh stop
    tmux kill-session -t TpInv

    stop_insights_proxy_docker_container
else
    stop_svc_in_tmux ${requested_svc}
fi
