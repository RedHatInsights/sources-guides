#!/bin/bash --login

cwd=$(pwd)

if [[ $cwd != *"sources-guides/scripts" ]]; then
  echo "Please switch to 'sources-guides/scripts' directory"
  exit
fi

source config.sh
source init-common.sh

set -e

#
# 1) create root directory
#
echo "-------------------------------------------------------"
echo "Creating root directory..."
mkdir -p ${root_dir}
cd ${root_dir}

#
# 2) download kafka
#

# if kafka directory exists including version from KAFKA_INSTALL_URL, then rename kafka diretory
if [ -d ${KAFKA_DIR_WITH_VERSION} ]; then
    mv ${KAFKA_DIR_WITH_VERSION} ${KAFKA_DIR}
fi

if [[ ! -d './kafka' ]]; then
    echo "-------------------------------------------------------"
    echo "Downloading Kafka..."
    wget -O kafka.tgz $KAFKA_INSTALL_URL
    tar -xzf kafka.tgz
    mv ./kafka_* ./kafka
fi

cd ${cwd}

#
# 3) make all scripts executable, create /scripts symlink
#
echo "-------------------------------------------------------"
echo "Making these scripts executable, creating symlink..."
chmod 744 ./*.sh
chmod 744 ./services/*.sh

[ -L ${root_dir}/scripts ] || ln -s ${cwd} ${root_dir}/scripts

#
# 4) clone forked/manageiq repos (checks for forks automatically)
#    skips existing clones
#
echo "-------------------------------------------------------"
echo "Cloning repositories..."
cd ${cwd}
./git/clone.sh

#
# 5) bundle gems
#
echo "-------------------------------------------------------"
echo "Bundle all repos"
gem install bundler
./bundle.sh update

#
# 6) create database.yml based on topological_inventory-api's/sources-api's database.dev.yml
#
echo "-------------------------------------------------------"
echo "Copying database.yml from topological_inventory-api/config/database.dev.yml..."

if [ -d ${TOPOLOGICAL_API_DIR} ]; then
    cd ${TOPOLOGICAL_API_DIR}
    dev_ymls=("config/database.yml"
              "../topological_inventory-core/config/database.yml"
              "../topological_inventory-persister/config/database.yml"
              "../topological_inventory-ingress_api/config/database.yml"
              "../topological_inventory-sync/config/database.yml")

    echo "Copying ${TOPOLOGICAL_API_DIR}/config/database.dev.yml"
    for dest_path in ${dev_ymls[@]}; do
        if [[ -f ${dest_path} ]]; then
            echo "[SKIPPED] File already exists: ${dest_path}"
        else
            cp config/database.dev.yml ${dest_path}
            echo "[OK] Copied to: ${dest_path}"
        fi
    done
else
    echo "Info: Directory ${TOPOLOGICAL_API_DIR} does not exist, skipping."
fi

echo "-------------------------------------------------------"
echo "Copying ${SOURCES_API_DIR}/config/database.dev.yml"
cd ${SOURCES_API_DIR}

dest_path="../sources-api/config/database.yml"
if [[ -f ${dest_path} ]]; then
    echo "[SKIPPED] File already exists: ${dest_path}"
else
    cp config/database.dev.yml ${dest_path}
    echo "[OK] Copied to: ${dest_path}"
fi

#
# 7) creates Gemfile.dev.rb
#
echo "-------------------------------------------------------"
echo "Creating Gemfile.dev.rb..."
for name in ${repositories[@]}
do
	cd "$root_dir/$name"
	if [[ -f ./Gemfile ]]; then
        if [[ ! -d "$root_dir/$name/bundler.d" ]]; then
            mkdir bundler.d
            touch ./bundler.d/.gitkeep
        fi
        cd bundler.d
        touch Gemfile.dev.rb
        echo "[OK] ${name}: Created bundler.d/Gemfile.dev.rb"
    else
        echo "[SKIPPED] ${name}: No Gemfile in project"
    fi
done

# 8) Configure UI
echo "-------------------------------------------------------"
if [ -d ${INSIGHTS_PROXY_DIR} ]; then
    cd ${INSIGHTS_PROXY_DIR}
    npm install

    echo "Patching /etc/hosts to connect localhost with CI/QA servers, please provide sudo credentials"
    sudo bash scripts/patch-etc-hosts.sh
    bash scripts/update.sh
else
    echo "Info: Directory ${INSIGHTS_PROXY_DIR} does not exist, skipping."
fi

if [ -d ${SOURCES_UI_DIR} ]; then
    cd ${SOURCES_UI_DIR}
    npm install
else
    echo "Info: Directory ${SOURCES_UI_DIR} does not exist, skipping."
fi

echo "-------------------------------------------------------"
echo "Successfully installed!"
echo ""
echo "--- And what next? ---"
echo "* Check all database.yml files (see above) and change db name if needed"
echo "* Run ./db/init.sh to create and initialize database, or:"
echo "    run ./db/reset.sh to reset and initialize database if exists"
echo "* Run ./start.sh to run persister and api services in TMUX"
echo "* Run ./start.sh <svc> to run service (run ./list-services.sh to see list of services)"
echo ""

LANG=C DOW=$(date +"%a")
echo "Happy $DOW! :)"
