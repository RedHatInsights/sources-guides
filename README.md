# Topological Inventory (tp-inv) guides

These guides describes how to install and run Topological Inventory and Sources locally. 
It also provides documentation of some Topological Inventory & Sources features in the [README](doc/README.md) 

It also describes how to deploy Topological Inventory and Sources by Clowder and Bonfire [Clowder README](scripts/clowder/README.md)

## Prerequisities

**RVM (optional)**

Ruby version manager
https://rvm.io/rvm/install  
If you're not using rvm, just remove content of [init-common.sh](scripts/init-common.sh) in case of problems.
If you're using rvm, create gemset for this project.

NOTE: On some systems, the use of rvm can cause the [install.sh](scripts/install.sh) script to terminate unexpectedly.
The solution, is to disable the specific feature of rvm that is the cause of the problem. To accomplish this, simply add the line: `export rvm_project_rvmrc=0` to your `$HOME/.rvmrc` file. For this to work, you must have current versions of the install scripts.

**TMUX**

Terminal multiplexer is required for automatized starting/restarting/stopping services in one session.
https://linuxize.com/post/getting-started-with-tmux/

**GitHub Token**

GitHub token is needed for API requests by install script. It detects which repositories you have forked and which not
https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line

**Kafka**

Kafka is messaging server used for sending data across services.
Just get the current link to latest stable archive there: https://kafka.apache.org/quickstart

**Docker**

Docker is needed for running UI service.
Installations steps here: https://docs.docker.com/install/linux/docker-ce/fedora/

Mac users: https://docs.docker.com/docker-for-mac/install/

**NPM**

NPM is needed for running UI service (and insights proxy)  
https://www.npmjs.com/get-npm

**Go**

If you want to run sources-superkey-worker, Go is needed.  
https://golang.org/dl/

**Config file**

Config file contains all information for installation and running services.  
Default values are filled in [config.default.sh](scripts/config.default.sh).
- Create *config.sh* with this content:
  ```
  #!/bin/bash
  # Define required values.
  root_dir="<your topological-inventory root dir>"
  MY_GITHUB_NAME="<your github name>"
  MY_GITHUB_TOKEN="<your github token>"
  ACCOUNT_NUMBER="<your account number>"
  SOURCES_PSK="<a key, use something secure like 1234 or $(uuidgen)>"

  # Define optional values, as needed.
  RVM_RUBY_VERSION_TP_INV="<your ruby version>"

  source "config.default.sh"
  ```
- Redefine values in `config.sh`:  
  - Required:  
    - Your github name: `MY_GITHUB_NAME`
    - Your github token: `MY_GITHUB_TOKEN`
    - Your account number - the account number you're using to log to CI server: `ACCOUNT_NUMBER`
    - Your root directory for repositories: `root_dir`
  - Optional
    - URL to kafka archive (see chapter above): `KAFKA_INSTALL_URL`
    - RVM ruby version you want to use (if using rvm, in `rvm use` format): `RVM_RUBY_VERSION_TP_INV`
    - RVM gemset name you want to use (if using rvm, in `rvm gemset use` format): `RVM_GEMSET_NAME_TP_INV`
    - PSK for sources-api if you would like to authenticate with a PSK rather than X-RH-IDENTITY
  - Logging
    Logging information can be captured by setting the `LOG_DIR` variable. When set, this variable contains the name of the directory under which per-service log files will be saved. The directory will be created if it does not exist. When not set or zero length, logging information will not be captured. For example:
    ```
    #!/bin/bash
    # Define required values.
    root_dir="<your topological-inventory root dir>"
    MY_GITHUB_NAME="<your github name>"
    MY_GITHUB_TOKEN="<your github token>"
    ACCOUNT_NUMBER="<your account number>"

    # Enable log capture
    LOG_DIR="svc_logs" 

    source "config.default.sh"
    ```
  - Source information
    The identification and authentication information for various sources can also be defined in `config.sh`. For example:
    ```
    #!/bin/bash
    # Define required values.
    root_dir="<your topological-inventory root dir>"
    MY_GITHUB_NAME="<your github name>"
    MY_GITHUB_TOKEN="<your github token>"
    ACCOUNT_NUMBER="<your account number>"

    # Define values for an Ansible provider.
    ANSIBLE_TOWER_SCHEME="https"
    ANSIBLE_TOWER_HOST="12.245.678.910"
    ANSIBLE_TOWER_USER="some_account"
    ANSIBLE_TOWER_PASSWORD="<account password>" 

    source "config.default.sh"
    ```

## Installation

- Create some root directory
- Clone these guides into it
- Switch to `scripts` directory 
- Run [install.sh](scripts/install.sh)
- Check your `config/database.yml` files if you want custom db name for **topological_inventory** service in repositories (all must point to the same db):
  - topological_inventory-api
  - topological_inventory-core
  - topological_inventory-persister
  - topological_inventory-sync
- Check your `config/database.yml` if you want custom db name for **sources** service
  - sources-api
- Run [db/init.sh](scripts/db/init.sh)
  - For developers, before running these commands, copy `v2_key.dev` to `v2_key` in the `sources-api` directory under your `$root_dir`.
  - If your db exists, you can run only [db/reset.sh](scripts/db/reset.sh) (existing data will be lost!)
  - Or [db/migrate.sh](scripts/db/migrate.sh) for migrations only

## Starting services

Starting Persister and API services is pretty easy:

- Switch to `scripts` directory (symlink was added to your repository `root_dir` by installation script)
- Run `start.sh` (list of services can be redefined by defining variable `$start_by_default` in `config.sh` - see [repositories.sh](scripts/repositories.sh))

Note: by default, topological inventory API is running on `localhost:3001`, sources API on `localhost:3002`. You can change it in `config.sh`

Starting collectors and operation workers:
- Fill service env variables (like credentials) in `scripts/config.sh` 
- Run `start.sh <service_name>`

You can find list by running [list-services.sh](scripts/list-services.sh).

## Restarting services
- Run `restart.sh <service_name>` 

## Stop all services:
- Run `stop.sh`

## Collectors

Collectors are responsible for collecting data from providers. Actually available:
- [Openshift collector](https://github.com/ManageIQ/topological_inventory-openshift)
- [Amazon collector](https://github.com/ManageIQ/topological_inventory-amazon)
- [Ansible Tower collector](https://github.com/ManageIQ/topological_inventory-ansible_tower)
- [Mock collector](https://github.com/ManageIQ/topological_inventory-mock_source)


## UI

When all services are started, access UI in browser on this URL:
https://ci.foo.redhat.com:1337/insights/settings/sources

## Maintenance / Daily operations

Following scripts helps with commonly used mass operations.

### GIT

- [pull.sh](scripts/git/pull.sh): Checkouts all unchanged repos to master and pulls changes
- [rebase.sh](scripts/git/rebase.sh): For all unchanged repos does the same as pull.sh and then rebases your current branch.
- [list-branches.sh](scripts/git/list-branches.sh): Prints current branches in all repos
- [list-changes.sh](scripts/git/list-changes.sh): Prints changes in all repos 
- [clone.sh](scripts/git/clone.sh): Cloning of repositories specified in config.sh. Part of install script.
- [cleanup.sh](scripts/git/cleanup.sh): Deletes branches merged to master. Without arg: local branches, with `--remote-cleanup` also deletes merged remote branches.

### Database
- [init.sh](scripts/db/init.sh): Creates databases, runs migrations and init-data.sh
- [init-data.sh](scripts/db/init-data.sh): Seeds, creates Tenants, SourceTypes and Sources
- [reset-dbs.sh](scripts/db/reset.sh): Resets databases (**deletes existing data!**) and seeds + creates Sources
- [migrate.sh](scripts/db/migrate.sh): Migrates both databases

### Other

- [bundle.sh](scripts/bundle.sh): Bundles all repositories which contains Gemfile
- [update.sh](scripts/update.sh): Bundles repositories with Gemfile, runs npm build on UI, insights-proxy repositories and runs migrations on `topological_inventory-core` and `sources-api`
- [haberdasher.sh](scripts/haberdasher.sh): Helps to run applications with using [haberdasher](https://github.com/RedHatInsights/haberdasher):
  ```
  Example 1 - with sending logs to kafka:
  ./haberdasher.sh ./services/openshift-operations.sh kafka
  
  Example 2 - without prepeding haberdasher command:
  ./haberdasher.sh ./services/openshift-operations.sh stderr without_hb
  ```
  Docs:
  ```
  ./haberdasher.sh <command_to_run> <desired_output> [<option_for_prepending_hb_command>]
  ```
  
  - `<command_to_run>` - (required) is command which will be run with haberdasher application
  - `<desired_output>` - (required) haberdasher can send message(logs) to kafka or stderr. 
                         This parameter controls it by values `kafka` or `stderr`:
  - `[<option_for_prepending_hb_command>]` - (optional) `without_hb`: run `<command_to_run>` without 
                                             prepending haberdasher application. It is useful because
                                             script `./haberdasher.sh` sets some variables which are 
                                             needed for development but running haberdasher application 
                                             is not necessary.
  
## Calling APIs

### From Shell Scripts
[API directory](scripts/api) contains scripts for querying Sources API and Tp-Inv API.  
They can be used directly from command line like:
- `cd scripts`
- `api/sources/get sources`
- response can be parsed with *jq* utility: `api/sources/get sources | jq '.'`
Or called from script with the same parameters, see [examples.sh](scripts/api/examples.sh)

### Through the Ruby API: `sources-api-client`
While there are good examples of this in the [sources-api-client-ruby](https://github.com/RedHatInsights/sources-api-client-ruby) repository, certain considerations must be taken when accessing the API service running locally in the developer's environment - specifically concerning authentication. An example of this is provided in [dev\_example.rb](scripts/api/sources/dev\_example.rb). Additionally, the [gen\_identity.sh](scripts/api/gen\_identity.sh) shell script is provided to facilitate the generation of the required `x_rh_identity` string.

More useful information can also be found in the [insights-api-common-rails](https://github.com/RedHatInsights/insights-api-common-rails) repository.
