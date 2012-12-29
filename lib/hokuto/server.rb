# -*- coding: UTF-8 -*-

module Hokuto
  # The class which epresents the server process.
  #
  #= Usage:
  #== Simple booting
  # <pre>Hokuto::Server.new(port: 8080).run</pre>
  class Server

    java_import org.eclipse.jetty.server.handler.ContextHandlerCollection
    java_import org.eclipse.jetty.server.nio.SelectChannelConnector
    Jetty = org.eclipse.jetty.server.Server

    attr_reader :http_port, :https_port
    attr_reader :jetty, :applications, :handler_collection, :certs

    # initialize the server.
    # _options_ :: server options. currently effective options are as below:
    #              <ul><li><strong>port</strong>: HTTP port to listen.</li>
    #              </ul>
    def initialize(options = {})
      @http_port = options[:port].to_i
      @https_port = options[:https_port].to_i if options[:https_port]
      @jetty = Jetty.new
      @applications = {}
      @handler_collection = ContextHandlerCollection.new
      jetty.handler = @handler_collection
    end

    # register the application.
    # 
    # _application_ :: The application to deploy. It must be an instance of Hokuto::Application.
    def add(application)
      previous_application = applications.delete application.context_root
      handler_collection.remove_handler previous_application.context if previous_application

      handler_collection.add_handler application.context
      applications[application.context_root] = application
    end

    # Boot server and returns immediately.
    def start
      [:INT, :TERM, :ABRT].each{|signal|Signal.trap(signal, ->{stop})}

      connector = SelectChannelConnector.new
      connector.port = http_port
      connector.confidential_port = https_port if https_port

      jetty.add_connector connector
      jetty.start
    end

    # Boot this server. Invocation of this method blocks the thread.
    def run
      start
      jetty.join
    end

    # Shutting down the server.
    def stop
      jetty.stop
    end
  end
end
