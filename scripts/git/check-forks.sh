#!/bin/bash

# Lists repositories and if they have forks or not
#
# NOTE: Edit your variables below!
source config.sh

cd $root_dir

for name in ${repositories[@]} 
do
    if [[ ! -d $name ]]; then
        echo "Skipping:   ${name}"
        continue
    fi

    forked=`curl --silent -H "Authorization: token ${MY_GITHUB_TOKEN}" -X GET "https://api.github.com/repos/$MY_GITHUB_NAME/$name" | grep "\"name\": \"$name\"" | wc -l`

    if [[ "$forked" -gt "0" ]]; then
        echo "Forked:     ${name}"
    else
        echo "NOT forked: ${name}"
    fi
done
