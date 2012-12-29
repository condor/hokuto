# -*- coding: UTF-8 -*-
#
# Hokuto: A Lightweight application server for JRuby/Rack applications.
# Authors:: Kevin TOYODA (condor1226@gmail.com)
# Version:: 0.0.2.8.1.8
# Copyright:: Copyright (C) Kevin TOYODA
# License:: MIT License
module Hokuto; end

require 'rubygems'

Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), '..', 'jars', '*.jar'))).each do |jar|
  require jar
end

require 'jruby-rack'


require "hokuto/version"
require 'hokuto/server'
require 'hokuto/application'
