#!/usr/bin/env bash

if [[ -f "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
    rvm use ${RVM_RUBY_VERSION_TP_INV}
    rvm gemset use ${RVM_GEMSET_NAME_TP_INV}
fi

function start_kafka {
    if [[ -n "$LOG_DIR" ]]; then
        tmux new-window -t TpInv -n kafka "services/kafka.sh start 2>&1 | tee ${LOG_DIR}/kafka.log"
    else
        tmux new-window -t TpInv -n kafka "services/kafka.sh start"
    fi
    echo "Waiting for Kafka initialization 20 sec..."
    sleep 20
    echo "Done"
}

function stop_kafka {
    ./services/kafka.sh stop
    sleep 1
    tmux kill-window -t TpInv:kafka &> /dev/null
}

function stop_insights_proxy_docker_container {
    local container_id=`docker container ls | grep "insightsproxy" | awk '{print $1}'`
    if [[ ! -z ${container_id} ]]; then
        echo "Stopping docker container \"insightsproxy\" (${container_id})"
        docker stop ${container_id}
    fi
}

function start_svc_in_tmux {
    local svc=$1

    if [[ ${svc} == "kafka" ]]; then
        start_kafka
    else
        if [[ -n "$LOG_DIR" ]]; then
            tmux new-window -t TpInv -n ${svc} "services/${svc}.sh 2>&1 | tee ${LOG_DIR}/${svc}.log"
        else
            tmux new-window -t TpInv -n ${svc} "services/${svc}.sh"
        fi
    fi
}

function stop_svc_in_tmux {
    local svc=$1

    if [[ ${svc} == "kafka" ]]; then
        stop_kafka
    elif [[ ${svc} == "insights-proxy" ]]; then
        tmux kill-window -t TpInv:${svc} &> /dev/null
        stop_insights_proxy_docker_container
    else
        tmux kill-window -t TpInv:${svc} &> /dev/null
    fi
}
