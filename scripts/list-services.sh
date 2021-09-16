#!/usr/bin/env bash

source config.sh

for file in $root_dir/scripts/services/*
do
    if [[ -f ${file} ]]; then
        echo $(basename -s ".sh" ${file})
    fi
done
