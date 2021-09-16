#!/bin/bash --login
#
# Script for mass bundle topology inventory plugins
# Usage: update.sh
#
source config.sh
source init-common.sh

previous_dir=`pwd`

cd ${root_dir}

operation=$1

for name in ${repositories[@]} 
do
	if [[ ! -d $name ]]; then
        echo
		echo "${name}: Directory does not exist, skipping."
		continue
	fi

	echo "$name -------------------------------------------------------"
	
	cd ${name}
		
	if [[ -f ./Gemfile ]]; then
		bundle update
	elif [[ ${name} == "insights-proxy" ]]; then
		npm install
		scripts/update.sh
	elif [[ ${name} == "topological_inventory-ui" ]]; then
		npm install
	else						
		echo "[SKIPPED] This repository doesn't have Gemfile"
	fi

	cd ..
done

cd $previous_dir

${root_dir}/scripts/db/migrate.sh
