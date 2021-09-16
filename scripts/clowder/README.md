# Deployment by Clowder and Bonfire
 
This doc describes how to deploy & cleanup Sources & Topological Inventory apps
either to your local minikube/CRC or remote cluster with ephemeral environments.

## Prerequisites
- Clone & install Bonfire (to the root_dir specified in your config.sh)
  - https://internal.cloud.redhat.com/docs/devprod/ephemeral/01-onboarding/

- Ruby gems used by i.e. sources api must be available    
- Copy `templates/sources.default.yaml` to `templates/sources.local.yaml`
- Copy `templates/topological.default.yaml` to `templates/topological.local.yaml`

- Podman (if you want to upload your quay images)  

If you want to use your minikube/openshift, follow the instructions: 
- https://github.com/RedHatInsights/clowder#getting-clowder
- oc apply -f templates/clowd-environment-*.yaml (change targetNamespace/namespace values in case of CRC) 

## Login 

Login to the minikube/openshift by `oc login`

## Deployment

### Configuration

Open your `sources.local.yaml`, there are several sections:
- configuration: 
  - local_root: directory where are cloned your topo/sources repos. Should be equal to `root_path` in your `config.sh` (in the `scripts dir`)
  - quay_root: namespace where you quay images live, usually quay.io/<username>
- repos_to_deploy:
  - comment items you don't want to deploy/cleanup
  - source: 
    - local: apps are deployed using your quay image/image tag, clowdapp.yaml in your local repo and parameters in the config
    - insights-production: apps are deployed using parameters in app-interface's production env
    - insights-stage: apps are deployed using parameters in app-interface's stage env
- common_parameters:
  - these parameters are used for all repos with `source: local` deployment
- apps:
  - these parameters are used with `source: local` deployment
  - IMAGE_TAGs are pointing to images in your `quay_root`
    - see the chapter "Creating Quay.io Images" for more details
    
###  Deploying

There is a `deployer.rb` which is parsing your `templates/sources.local.yaml` and does the following:
- deploying to your openshift/minikube
- get/reserve an ephemeral namespace and deploy to the ephemeral cluster
- cleanup

Usage: 
```
./deployer.rb --config=templates/sources.local.yaml 
              --target=[ephemeral|local]
              [--cleanup]
              [--dry-run]
              
Options:
-c, --config=<s>: path to your config
-l, --target=<s>: switch between ephemeral cluster/local minikube(crc)
-d, --cleanup (optional): deletes apps specified in your sources.local.yaml in "repos_to_deploy" section
-t, --dry-run (optional): reserves env, parses config, but doesn't deploy
-h, --help: Shows this help 
```

The deployer parses your `sources.local.yaml` and generates `templates/bonfire-sources.local.yaml` which is used for the deployment
(similarly it generates `topological.local.yaml` -> `bonfire-topological.local.yaml`)

## Creating Quay.io Images

If you want to use images from your local source code, follow these steps:
- create quay repository (in your `quay_root`) with the same name as an app name (it means GH repository name with '-' instead of '_')
- remove `.bundle` directory from your local repository
- run `export QUAY_ROOT="quay.io/<user>"`
    - i.e. `export QUAY_ROOT="quay.io/mslemr"`
- run `cd <your local repository>; ../scripts/clowder/quay.sh <quay repository>`
    - i.e `cd ~/Projects/RedHatInsights/sources-api; ../scripts/clowder/quay.sh sources-api`
    - it returns the IMAGE_TAG value
    - set env variable IMAGE_BUILDER determine which command is used to build images, supported values are `podman` or `docker` (Default is `docker`).
      - i.e. `cd ~/Projects/RedHatInsights/sources-api; env IMAGE_BUILDER=docker ../scripts/clowder/quay.sh sources-api`
      - NOTE: For Mac OS is recommended `docker`
    - set env variable CACHE which determines whether image is build from cache: value is `no-cache` - without cache (default is with cache)
     - i.e. `cd ~/Projects/RedHatInsights/sources-api; env CACHE=no-cache ../scripts/clowder/quay.sh sources-api`
