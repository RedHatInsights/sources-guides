#!/bin/bash --login

source config.sh
source init-common.sh

echo "Starting insights upload service"

cd "$root_dir/insights-upload"
python3.7 -m venv env
. env/bin/activate
pip install -r requirements.txt
# Needs running kafka and topics.json with defined mime type vnd.redhat.topological-inventory
STORAGE_DRIVER=localdisk INVENTORY_URL="http://localhost:8888/api/hosts" KAFKAMQ=localhost:9092 TOPIC_CONFIG="/home/mslemr/Projects/topological-inventory/topics.json" python app.py
