require "listen"
require "rb-fsevent"
#require 'readline'
require "ripl"
require "looksee"

require "pathname"
require "benchmark"

unless $LOAD_PATH.include?(File.dirname(__FILE__))
  $LOAD_PATH << File.dirname(__FILE__)
end

require "speci/listener"
require "speci/console"
require "speci/spec_runner"
require "speci/version"

module Speci
  extend self

  @specs_to_run = []
  @last_specs
  @root_path = ""
  attr_reader :root_path
  attr_accessor :specs_to_run
  attr_accessor :last_specs

  def start
    @root_path = Dir.pwd

    Listener.start
    require 'rspec/core'

    Console.readline
  end

  def restart!
    exec "ruby #{$PROGRAM_NAME}"
  end

  def reload_rails!
    if defined?(ActionDispatch)
      ActionDispatch::Reloader.cleanup!
      ActionDispatch::Reloader.prepare!
      puts "Reloading..."
    end
  end
end