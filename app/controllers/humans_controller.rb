require_relative '../../lib/controller_base'
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/../models/*.rb') { |file| require file }
