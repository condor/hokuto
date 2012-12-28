# -*- coding: UTF-8 -*-

require 'java'
require 'jruby-rack'

module Hokuto
  class Application

    java_import org.eclipse.jetty.webapp.WebAppContext
    java_import org.jruby.rack.RackFilter
    java_import javax.servlet.DispatcherType
    java_import java.util.EnumSet

    attr_reader :context, :context_root, :base_directory, :descriptor, :environment,
      :min_instances, :max_instances

    def initialize(args)

      @context = WebAppContext.new

      if args[:descriptor]
        context.descriptor = args[:descriptor]
      else
        @environment = args[:environment]
        @context_root = args[:context_root]
        @base_directory = args[:base_directory]
        @min_instances = args[:min_instances]
        @max_instances = args[:max_instances]

        setup_context
      end
    end

    def ==(other)
      return false unless other.kind_of? Application
      other.context_root == context_root
    end

    private
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
