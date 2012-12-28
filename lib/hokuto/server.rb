# -*- coding: UTF-8 -*-

# represents the server process.
module Hokuto
  class Server

    java_import org.eclipse.jetty.server.handler.ContextHandlerCollection
    java_import org.eclipse.jetty.server.nio.SelectChannelConnector
    Jetty = org.eclipse.jetty.server.Server

    attr_reader :http_port, :https_port
    attr_reader :jetty, :applications, :handler_collection, :certs

    # initialize the server.
    #
    def initialize(options = {})
      @http_port = options[:port].to_i
      @https_port = options[:https_port].to_i if options[:https_port]
      @jetty = Jetty.new
      @applications = {}
      @handler_collection = ContextHandlerCollection.new
      jetty.handler = @handler_collection
    end

    # register the application.
    def add(application)
      previous_application = applications.delete application.context_root
      handler_collection.remove_handler previous_application.context if previous_application

      handler_collection.add_handler application.context
      applications[application.context_root] = application
    end

    # booting the server.
    def run
      [:INT, :TERM, :ABRT].each{|signal|Signal.trap(signal, ->{stop})}

      connector = SelectChannelConnector.new
      connector.port = http_port
      connector.confidential_port = https_port if https_port

      jetty.add_connector connector
      jetty.start

      jetty.join
    end

    # shutting down the server.
    def stop
      jetty.stop
    end
  end
end
