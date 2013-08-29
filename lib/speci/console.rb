module Ripl::Shell::API
  alias_method :eval_input_super, :eval_input
  def eval_input(input)
    halt = Speci::Console.process_line(input)
    eval_input_super(input) unless halt
  end
end

module Speci
  module Console
    extend self

    def readline
      Ripl.config[:irbrc] = false
      Ripl::Commands.include(Speci::Console::Commands)
      Ripl.start
      return
      loop do
        line = Readline::readline('> ')
        break if line.nil? || line == 'quit' || line == 'exit'
        Readline::HISTORY.push(line) unless line == ""
        process_line(line)
        run_specs
      end
    end

    def process_line(line)
      do_run_specs = false
      case line
        when "*"            then
          mark_all_specs_to_run
          do_run_specs = true
        when "quit", "exit" then exit
      end

      # empty line
      if line =~ /^\s*$/
        do_run_specs = true
      end

      # spec/*
      if line.start_with?('spec/')
        if line.end_with?('*')
          line = line + '*/*_spec.rb'
        end
        Speci.specs_to_run.push(*Dir[root_path.join(line).to_s])
        do_run_specs = true
      end

      # spec all
      # spec again
      # spec
      if line.start_with?('spec')
        parts = line.split(' ')
        case parts[1]
          when 'all'          then mark_all_specs_to_run
          when 'again', nil   then Speci.specs_to_run.push(*Speci.last_specs)
          else
            puts "unknown command '#{parts[1]}'"
        end

        do_run_specs = true
      end

      if do_run_specs
        run_specs
        return true
      else
        return false
      end
    end

    def mark_all_specs_to_run
      Speci.specs_to_run.push *Dir[root_path.join('spec/**/*_spec.rb').to_s]
    end

    def run_specs
      if Speci.specs_to_run.size > 0
        specs_tmp = Speci.specs_to_run.dup
        Speci.last_specs = Speci.specs_to_run.dup
        Speci.specs_to_run.clear

        print "running specs "
        p specs_tmp.map {|f| f.sub(Speci.root_path + '/', '') }

        puts Benchmark.measure {
          begin
            SpecRunner.run_specs(specs_tmp)
          rescue => e
            puts e.message
            puts e.backtrace
          end
        }
      else
        puts "no specs to run"
      end
    end

    def eval_line(line)
      begin
        res instance_eval(line)
        p res
      rescue Object => e
        p e.message
      end
    end

    def root_path
      @root_path ||= Pathname.new(Speci.root_path)
    end
  end
end

module Speci::Console::Commands
  def reload!
    Speci.reload_rails!
  end

  def restart
    Speci.restart!
  end

  def spec
    # just autocomplete
  end
end