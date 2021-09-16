#!/bin/bash --login

source config.sh
source init-common.sh

cd ${root_dir}

#echo "Migrating Topological Inventory..."
#cd topological_inventory-persister
#bundle exec rake db:migrate
#cd ..
#echo "[DONE] Migrating Topological Inventory"

echo "Migrating Sources"
cd ${SOURCES_API_DIR}
bundle exec rake db:migrate
cd ..
echo "[DONE] Migrating Sources"
