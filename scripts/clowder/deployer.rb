#!/usr/bin/env ruby

require "optimist"
require "active_support/core_ext/object"
require_relative "deployer/worker"

def parse_args
  Optimist.options do
    opt :config, "Path to config file", :type => :string, :required => true
    opt :cleanup, "Deletes apps specified by config"
    opt :dry_run, "Generates config, no deploy"
    opt :target, "ephemeral|local", :type => :string
  end
end

args = parse_args
Optimist.die :config, "can't be blank" if args[:config].blank?
Optimist.die :target, "must be [local|ephemeral]" unless %w[local ephemeral].include?(args[:target])

puts "---- TEST ----" if args[:dry_run]

if args[:target] != 'local' || !args[:dry_run]
  oc_user = `oc whoami`
  if oc_user.blank?
    puts "You're not logged by the oc command, exiting"
    exit(-1)
  end
end

# ------
# STEP 1
#
puts "Parsing config file..."
worker = Clowder::Deployer::Worker.new(:input_config => args[:config])
worker.parse

# ------
# STEP 2
#
args[:cleanup] ? print("Cleaning ") : print("Deploying to ")

if args[:target] == 'ephemeral'
  puts "the ephemeral cluster..."
  namespace = worker.my_ephemeral_namespace
  namespace = worker.reserve_ephemeral_namespace if namespace.nil? && !args[:cleanup]

  env = "env-#{namespace}" if namespace.present? && namespace.include?('ephemeral')
else # mode == local
  puts "the local crc/minikube..."
  namespace = nil
  env = 'dev-env'
end

puts "Namespace: #{namespace || '<current>'}, env: #{env}"

# ------
# STEP 3
#
if env.present?
  worker.make_config(env)
  puts "- local Bonfire config generated to #{worker.output_config_file}"
else
  puts "No available environment, exiting"
  exit(-1)
end

# ------
# STEP 4
#
if args[:cleanup]
  puts "Deleting apps..."
  worker.cleanup(namespace)

  `oc get app`
else
  unless args[:dry_run]
    puts "- deployment in progress..."
    worker.deploy(namespace)

    `oc project #{namespace}` if args[:target] == 'ephemeral'
    puts "- deployment finished"
  end
end
