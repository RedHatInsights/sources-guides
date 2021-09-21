#!/bin/bash --login

source config.sh
source init-common.sh

cwd=$(pwd)

if [ -d ${TOPOLOGICAL_API_DIR} ]; then
    cd ${TOPOLOGICAL_API_DIR}
    bundle exec rake db:create
else
    echo "Info: Directory ${TOPOLOGICAL_API_DIR} does not exist, skipping."
fi

cd ${SOURCES_API_DIR}
bundle exec rake db:create

cd ${cwd}
db/migrate.sh
db/init-data.sh
