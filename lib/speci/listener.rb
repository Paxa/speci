module Speci
  module Listener
    extend self

    def start
      @listener = Listen.to(root_path.to_s)
      @listener = listener.ignore(%r{^.git})
      @listener = listener.filter(/\.rb$/)
      @listener = listener.latency(0.5)

      @listener = @listener.polling_fallback_message(false)

      @listener = @listener.change do |files|
        begin
          files.delete_if {|file| file == __FILE__ }
          files.each do |file|
            file = file.sub($root_path, '')
            if file == "spec/spec_helper.rb"
              puts "Force reload #{file}"
              Speci.restart!
            elsif file.start_with?('spec/')
              Speci.specs_to_run << file unless $specs_to_run.include?(file)
            end
          end

          puts "Files changed #{files.inspect}"

          if defined?(ActionDispatch) && files.select {|f| !f.start_with?('spec/') }.size > 0
            ActionDispatch::Reloader.cleanup!
            ActionDispatch::Reloader.prepare!
            puts "Reloading..."
          end
        rescue => e
          puts e.message
          puts e.backtrace
        end
      end

      puts 'start listener'
      @listener.start
    end
  end
end