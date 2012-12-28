# -*- coding: UTF-8 -*-
require 'rubygems'

Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), '..', 'jars', '*.jar'))).each do |jar|
  require jar
end

require 'jruby-rack'

module Hokuto; end

require "hokuto/version"
require 'hokuto/server'
require 'hokuto/application'
