require 'yaml'
require "psych"

module Clowder
  module Deployer
    class Worker
      attr_accessor :output_config_file

      DEFAULT_CLOWDAPP_PATH = "deploy/clowdapp.yaml".freeze

      def initialize(input_config:)
        @input_config_file = input_config
        @output_config_file = nil

        @input, @output = {}, {}
      end

      def parse
        load_config

        @configuration  = @input['configuration']
        @default_params = @input['common_parameters']
        @repos          = {}.tap { |repos| @input['repos_to_deploy'].each {|repo| repos[repo['name']] = repo['source']} }
        @apps_parameters  = @input['apps']
      end

      def make_config(env = nil)
        generate_output(env)

        dump_to_file
      end

      def my_ephemeral_namespace
        puts "- checking reserved namespace..."
        cmd = "#{bonfire_command} namespace list --mine | tail -n 1 | awk '{print $1}'"
        namespace = `#{cmd}`

        namespace.strip if namespace.present? && namespace.include?('ephemeral')
      end

      def reserve_ephemeral_namespace
        puts "- reserving namespace..."
        cmd = "#{bonfire_command} namespace reserve"
        `#{cmd}`.strip
      end

      def deploy(namespace = nil)
        @repos.each_pair do |name, source|
          app_name = repo_to_app_name(name)

          cmd = if %w[insights-production insights-stage].include?(source)
                  "#{bonfire_command} config get -a #{app_name} --ref-env #{source}"
                elsif source == 'local'
                  "#{bonfire_command} local get -a #{app_name} -c #{@output_config_file}"
                else
                  raise "Repository #{name} requested unknown source of parameters: #{source}"
                end

          cmd += " | oc apply -f -"
          cmd += " -n #{namespace}" if namespace.present?
          `#{cmd}`
        end
      end

      def cleanup(namespace)
        @repos.each_key do |name|
          app_name = repo_to_app_name(name)

          puts "- #{app_name}"
          cmd = "oc delete app #{app_name}"
          cmd += " -n #{namespace}" if namespace.present?
          `#{cmd}`
        end
      end

      private

      def load_config
        file = File.read(@input_config_file)
        yaml = Psych.parser.parse(file)
        @input = yaml.handler.root.to_ruby[0]
      rescue Psych::SyntaxError => ex
        puts "Parsing of #{@input_config_file} failed: #{ex.message}"
        raise
      end

      def output_filename
        input_filename = @input_config_file.split('/').last
        "bonfire-#{input_filename}"
      end

      def generate_output(env)
        @output_config_file = File.join(@configuration['local_root'], 'scripts/clowder/templates', output_filename)
        @output['envName'] = env
        @output['apps'] = []
        @repos.each_key do |repo|
          app_name = repo_to_app_name(repo)

          defaults = load_defaults(app_name)
          raise "Missing defaults for #{app_name}" if defaults.nil?

          @default_params.each_pair do |name, value|
            defaults['parameters'][name] = value
          end

          defaults['repo'] = File.join(@configuration['local_root'], repo)
          defaults['path'] = DEFAULT_CLOWDAPP_PATH
          defaults['host'] = 'local'
          defaults['parameters']['ENV_NAME'] = env
          defaults['parameters']['IMAGE'] = File.join(@configuration['quay_root'], repo_to_quay_name(repo))

          @output['apps'] << defaults
        end
      end

      def load_defaults(app_name)
        @apps_parameters.select {|app| app['name'] == app_name}.first
      end

      def repo_to_app_name(repo)
        repo.gsub('_', '-').gsub('topological-inventory', 'topo')
      end

      def repo_to_quay_name(repo)
        repo.gsub('_', '-')
      end

      def dump_to_file
        File.open(@output_config_file, 'w') do |file|
          file.write(Psych.dump(@output))
        end
      end

      def bonfire_command
        cmd = "cd #{File.join(@configuration['local_root'], 'bonfire')}; "
        cmd + "source .venv/bin/activate; bonfire "
      end
    end
  end
end
