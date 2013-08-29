require "listen"
require "rb-fsevent"
require 'readline'

require "pathname"
require "benchmark"

require "speci/listener"
require "speci/console"
require "speci/spec_runner"
require "speci/version"

module Speci
  extend self

  @specs_to_run = []
  @last_specs
  @root_path = ""
  attr_reader :root
  attr_accessor :specs_to_run
  attr_accessor :last_specs

  def start
    @root_path = Dir.pwd

    Listener.start
    require 'rspec/core'
  end

  def restart!
    exec "ruby #{$PROGRAM_NAME}"
  end

end