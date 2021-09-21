#!/bin/bash --login

source config.sh
source init-common.sh

cd ${root_dir}

if [ -d ${TOPOLOGICAL_API_DIR} ]; then
    echo "Migrating Topological Inventory..."
    cd topological_inventory-persister
    bundle exec rake db:migrate
    cd ..
    echo "[DONE] Migrating Topological Inventory"
else
    echo "Info: Directory ${TOPOLOGICAL_API_DIR} does not exist, skipping."
fi

echo "Migrating Sources"
cd ${SOURCES_API_DIR}
bundle exec rake db:migrate
cd ..
echo "[DONE] Migrating Sources"
