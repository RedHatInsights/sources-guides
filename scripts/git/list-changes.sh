#!/usr/bin/env bash

# Script for list your changes in all repos
#
# NOTE: Edit your variables below!
source config.sh

cd $root_dir

empty_line=1

for name in ${repositories[@]}
do
	if [[ ! -d $name ]]; then
		echo "${name}: Directory does not exist, skipping."
		continue
	fi

	cd $name
	current_branch=$(git rev-parse --abbrev-ref HEAD)

	if git diff-index --quiet HEAD --; then
		echo "${name}:    No Changes (${current_branch})"
		empty_line=0
   	else
   	    if [[ ${empty_line} -eq 0 ]]; then
   	        echo ""
   	    fi
	    echo "<$name> -------------------------------------------------------"
		git status -s -b
		echo "</$name> ------------------------------------------------------"
		echo ""
		empty_line=1
	fi

	cd ..
done
