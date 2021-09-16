#!/bin/bash
#
# Script for cloning topology inventory and sources repos
#
# * creates root directory defined in config.sh
# * if repo directory exists, skips cloning repo 
# * otherwise checks if your fork exists (github name defined in config.sh)
# * if exists, clones fork and adds ManageIQ as upstream
# * if not exists, clones ManageIQ as origin
#
# Usage: clone.sh
#
# NOTE: Edit your variables below!
source config.sh

mkdir -p ${root_dir}
cd ${root_dir}

for name in ${repositories[@]} 
do
    if [[ ${name} == "inventory_refresh" ]]; then
        upstream_org="ManageIQ"
    else
        upstream_org="RedHatInsights"
    fi

	echo "----------------------------------------------------------------------"
	#
	# 1) Check if repo already cloned
	#
	if [[ -d "$root_dir/$name" ]]; then
		echo "* [INFO][SKIPPED] Cloning into: $name"
		echo "* Repository directory already found"
	else
		echo "* Cloning into: $name"
		#
		# 1) Check if repo is forked
		#
		forked=`curl --silent -H "Authorization: token ${MY_GITHUB_TOKEN}" -X GET "https://api.github.com/repos/$MY_GITHUB_NAME/$name" | grep "\"name\": \"$name\"" | wc -l`
		if [[ "$forked" -gt "0" ]]; then
			echo "[INFO][FOUND] Fork git@github.com:$MY_GITHUB_NAME/$name"
		else
			echo "[INFO][NOT FOUND] Fork git@github.com:$MY_GITHUB_NAME/$name not found. Using $upstream_org repo as origin."
		fi	
		echo " "	
		#
		# 2 ) Clone
		#	
		# 2a) Clone your forks, adding upstream
		if [[ "$forked" -gt "0" ]]; then
			git clone git@github.com:$MY_GITHUB_NAME/$name $name
			cd $name
			git remote add upstream git@github.com:$upstream_org/$name
			cd ..
		# 2b) Clone from ManageIQ/RedHatInsights namespace
		elif [[ "$forked" -eq "0" ]]; then
			git clone git@github.com:$upstream_org/$name
		fi	
	fi
	echo " "
done
