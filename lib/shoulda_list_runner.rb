require 'test/unit'
require 'test/unit/ui/console/testrunner'

module Color
  COLORS = { :clear => 0, :red => 31, :green => 32, :yellow => 33 }
  def self.method_missing(color_name, *args)
    color(color_name) + args.first + color(:clear) 
  end
  def self.color(color)
    "\e[#{COLORS[color.to_sym]}m"
  end
end

module Test
  module Unit
    module UI
      module Console
        class TestRunner
          def test_finished(name)
            if is_fault?(name)
              puts Color.red(name.gsub(/test: /, ""))
            else
              puts Color.green(name.to_s.gsub(/test: /, ""))
            end
          end
          
          def is_fault?(name)
            !_faults_by_name[name].nil?
          end
          
          def _faults_by_name
            @_faults_by_name ||= {}
          end
          
          def add_fault(fault)
            @faults << fault
            _faults_by_name[fault.test_name] = fault
          end
        end
      end
    end
  end
end