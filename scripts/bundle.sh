#!/bin/bash --login
#
# Script for mass bundle topology inventory plugins
# Usage: bundle.sh [install|update]
#
# NOTE: Edit variables in config.sh!
source config.sh
source init-common.sh

cd $root_dir

operation=$1

if [[ "$operation" == "install" || "$operation" == "update" ]]; then
	for name in ${repositories[@]} 
	do
		if [[ ! -d $name ]]; then
			echo
			echo "${name}: Directory does not exist, skipping."
			continue
		fi
        
		echo "$name -------------------------------------------------------"
	
		cd $name
			
		if [[ -f ./Gemfile ]]; then
			if [[ "$operation" == "update" ]]; then
				bundle update
			elif [[ "$operation" == "install" ]]; then
				bundle install
			fi
		else
			echo "[SKIPPED] This repository doesn't have Gemfile"
		fi

		cd ..
	done
else
	# Print help
	echo "Usage: bundle.sh [install|update]"
fi

