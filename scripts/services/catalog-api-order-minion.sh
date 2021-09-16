#!/bin/bash --login
echo "Catalog API Order Minion"
source config.sh
source init-common.sh

cd $root_dir/catalog-api-minion
bin/catalog-api-order-minion
