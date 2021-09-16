#!/bin/bash

# Script for git updating git branch master topology inventory plugins
# Switches to master branches
#
# NOTE: Edit your variables below!
source config.sh

cd $root_dir

modified_repos=()

for name in ${repositories[@]} 
do
	if [[ ! -d $name ]]; then
		echo
		echo "${name}: Directory does not exist, skipping."
		continue
	fi
	
	echo "$name -------------------------------------------------------"
	cd $name
	current_branch=$(git rev-parse --abbrev-ref HEAD)


	if git diff-index --quiet HEAD --; then
		git fetch --all --prune
		git checkout master
	
		has_upstream=`git branch -a | grep upstream | wc  -l`

		if [[ "$has_upstream" -gt "0" ]]; then
			git pull upstream master
			git push origin master
		else
			git pull origin master
		fi
	else
		echo "Changes in branch ${current_branch}"
		modified_repos+=($name)
	fi
	
	cd ..
done

echo ""
echo "Repositories with changes (cannot apply git pull):"
for name in ${modified_repos}
do
	echo $name
done

