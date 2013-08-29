module Speci
  module SpecRunner
    extend self

    def run_specs(files)
      options = RSpec::Core::ConfigurationOptions.new(files)
      options.parse_options
      RSpec::Core::CommandLine.new(options, RSpec::configuration.dup).run($stderr, $stdout)
    ensure
      reset
    end

    def preload_spec_helper
      spec_helper_location = File.join(Speci.root_path, 'spec/spec_helper.rb')
      unless $LOADED_FEATURES.include?(spec_helper_location)
        require spec_helper_location
      end
    end

    def reset
      conf = RSpec::configuration
      conf.reset
      RSpec.reset
      RSpec::configuration = conf
    end
  end
end