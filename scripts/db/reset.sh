#!/bin/bash --login
# Script for reset and initialization Topological inventory database
#
# NOTE: Edit your variables below
source config.sh
source init-common.sh

if [ -d ${TOPOLOGICAL_INVENTORY_CORE} ]; then
    cd ${TOPOLOGICAL_INVENTORY_CORE}
    bundle exec rake db:setup
else
    echo "Info: Directory ${TOPOLOGICAL_INVENTORY_CORE} does not exist, skipping."
fi

if [ -d ${SOURCES_API_DIR} ]; then
    cd ${SOURCES_API_DIR}
    bundle exec rake db:setup
    bundle exec rake db:migrate
else
    echo "Info: Directory ${SOURCES_API_DIR} does not exist, skipping."
fi

if [ -d ${TOPOLOGICAL_API_DIR} ]; then
    cd ${TOPOLOGICAL_API_DIR}
    bundle exec rake db:migrate
else
    echo "Info: Directory ${TOPOLOGICAL_API_DIR} does not exist, skipping."
fi

cd ${root_dir}/sources-guides/scripts
db/init-data.sh
