# -*- coding: UTF-8 -*-

require 'rubygems'
require 'rack'
require 'java'
require 'optparse'

require 'hokuto/server'

require 'optparse'
require 'yaml'

module Hokuto

  #The entry point module to invoke the Jetty server.
  #This module prepares the default value of any application.
  module Main

    #Run the server.
    #
    #
    #= Arguments
    #_options_:: Server and Application options given by commandline arguments. Currently effective items are below:
    #=== whole configuration
    #- -f,--config-file=CONFIG_FILE:: The path to the configuration YAML file.
    #=== server configuration
    #- -p,--port=HTTP_PORT:: The port where HTTP server listens. Default: 7080
    #=== application configuration
    #- -w,--web-xml=WEBXML:: The path to your application's web.xml
    #- -c,--context-root=PATH:: The context root of your app. Default: '/'
    #- -d,--base-directory=DIR:: The directory where your application is. Default: current working directory
    #- -e,--environment=ENV:: The value of RACK_ENV variable your application runs under. Default: 'environment'
    #- -s,--min-instances=INSTANCES_ON_STARTUP:: The number of the JRuby runtime instances for your app on startup.
    def self.run(options)
      config = parse_arguments(options)

      if config_file = config.delete(:config_file)
        config = YAML.load_file(config_file)
      end

      if config.include? :application
        application_configs = [config.delete(:application)]
      else
        application_configs = config.delete(:applications)
      end

      server = Server.new(config)
      application_configs.each do |application_config|
        server.add Application.new(application_config)
      end if application_configs
      server.run
    end

    # :nodoc:
    #
    def self.parse_arguments(options)
      result = {
        port: 7080,
      }
      app_config = {
        environment: 'development',
        context_root: '/',
        base_directory: Dir.pwd,
        min_instances: 1,
        max_instances: 1
      }
      parser = OptionParser.new
      parser.on('-f', '--config-file=CONFIG_FILE'){|v|app_config[:config_file] = YAML.load_file(v)}
      parser.on('-w', '--web-xml=WEBXML'){|v|app_config[:descriptor] = v}
      parser.on('-p', '--http-port=HTTP_PORT'){|v|result[:port] = v}
      parser.on('-P', '--https-port=SECURE_PORT'){|v|result[:https_port] = v}
      parser.on('-c', '--context-root=PATH'){|v|app_config[:context_root] = v}
      parser.on('-d', '--base-directory=DIR'){|v|app_config[:base_directory] = v}
      parser.on('-e', '--environment=ENV'){|v|app_config[:environment] = v}
      parser.on('-s', '--min-instances=INSTANCES_ON_STARTUP'){|v|app_config[:min_instances] = v}
      parser.on('-x', '--max-instances=MAXIMUM_INSTANCES'){|v|app_config[:max_instances] = v}
      parser.parse! options

      app_config[:base_directory] ||= Dir.pwd

      result.merge!(:application => app_config) unless app_config.empty?
      result
    end

    class << self
      private :parse_arguments
    end
  end
end
