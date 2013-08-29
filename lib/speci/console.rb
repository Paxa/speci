module Speci
  module Console
    extend self

    def readline
      loop do
        line = Readline::readline('> ')
        break if line.nil? || line == 'quit' 
        Readline::HISTORY.push(line) unless line == ""
        if line !~ /^\s*$/
          if line.start_with?('spec/')

            if line.end_with?('*')
              line = line + '*/*_spec.rb'
            end

            Speci.specs_to_run.push *Dir[root_path.join(line).to_s]
          elsif line.start_with?('spec ')
            parts = line.split(' ')
            case parts[1]
              when 'all' then Speci.specs_to_run.push *Dir[root_path.join('spec/**/*_spec.rb').to_s]
              when 'again' then Speci.specs_to_run.push *$last_specs
              else
                puts "unknown command '#{parts[1]}'"
            end
          else
            begin
              instance_eval(line)
            rescue Object => e
              p e.message
            end
          end
        end

        if Speci.specs_to_run.size > 0
          specs_tmp = Speci.specs_to_run.dup
          Speci.last_specs = Speci.specs_to_run.dup
          Speci.specs_to_run.clear

          print "running specs "
          p specs_tmp

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
    end

  end
end