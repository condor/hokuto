# -*- coding: UTF-8 -*-

require 'java'
require 'jruby-rack'

module Hokuto
  # Represents the web application to deploy.
  #
  class Application

    java_import org.eclipse.jetty.webapp.WebAppContext
    java_import org.jruby.rack.RackFilter
    java_import javax.servlet.DispatcherType
    java_import java.util.EnumSet

    attr_reader :context, :context_root, :base_directory, :descriptor, :environment,
      :min_instances, :max_instances

    # Initialize the application. The process is such below:
    #
    # 1. Allocate the Jetty's WebAppContext instance.
    # 2. Initializes this application with the file pointed by :descriptor option if given.
    # 3. If not, initialize the configurations of this application with given options.
    #
    # Notice: The class doesn't have any responsibility to give the default values.
    # The class responsible to set defaults is Hokuto::Main. 
    #
    # _options_ :: Application options. It can include the following parameters:
    #              <ul>
    #               <li><strong>:descriptor</strong>: The path for your web.xml. <br />Note: All other options are ignored if you give this option.</li>
    #               <li><strong>:environment</strong>: The value of RACK_ENV environmental variable. If you use RoR, set this value correctly.</li>
    #               <li><strong>:context_root</strong>: The context root path of this application.</li>
    #               <li><strong>:base_directory</strong>: The path where application root (nearly equals to the directory where config.ru exists).</li>
    #               <li><strong>:min_instances</strong>: The number of JRuby runtimes allocated on startup. In the production environment, this should be equal to :max_instances option.</li>
    #               <li><strong>:max_instances</strong>: The maximum number of JRuby runtimes which is going to be allocated. If you don't use any thread-unsafe library, you should make your apps thread-safe and turn this value to 1 on the production environment.</li>
    #              </ul>
    def initialize(options)

      @context = WebAppContext.new

      if options[:descriptor]
        context.descriptor = options[:descriptor]
      else
        @environment = options[:environment]
        @context_root = options[:context_root]
        @base_directory = options[:base_directory]
        @min_instances = options[:min_instances]
        @max_instances = options[:max_instances]

        setup_context
      end
    end

    # Provides the method to compare.
    # This comparison consists of the comparison of only the context_root attribute.
    # This method is mainly used for the management for the applications deployed on any server.
    def ==(other)
      return false unless other.kind_of? Application
      other.context_root == context_root
    end

    private
    # Sets the option values given at the initialization phase to the Jetty's WebAppContext this instance contains..
    def setup_context
      # context configuration statically defined.
      context.add_filter(RackFilter.java_class.name, '/*', java.util.EnumSet.allOf(javax.servlet.DispatcherType))
      context.set_init_parameter('public.root', 'public')
      context.add_event_listener(org.jruby.rack.RackServletContextListener.new)

      # context configuration determined by given configuration parameters.
      context.resource_base = base_directory
      context.context_path = context_root
      context.set_init_parameter('rack.env', environment)
      context.set_init_parameter('jruby.min.runtimes', min_instances.to_s)
      context.set_init_parameter('jruby.max.runtimes', max_instances.to_s)
    end
  end
end
