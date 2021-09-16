#!/usr/bin/env bash
# List of repositories/services/directories/TMUX windows for all mass operations
# This file is included in config[.dev].sh, redefine variables in your config.sh file if you need :)

# Array of repositories maintained by other scripts
repositories=(#"inventory_refresh"
              #"insights-proxy"
              "sources-api"
              #"sources-api-client-ruby"
              "sources-monitor"
              "sources-satellite"
              "sources-superkey-worker"
              #"sources-ui"
              "sources-api-go"
             )

# When script "start.sh" is run without parameters, these services are started.
# Overwrite in your config.sh, if you want different list
: ${start_by_default:="kafka"
                       "sources-api"
                      #"persister"
                      #"ingress-api"
                      #"topological-api"
                      #"sources-sync"
                      #"insights-proxy"
                      }

