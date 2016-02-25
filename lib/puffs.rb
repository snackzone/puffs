require_relative 'version'

`'chmod +x bin/puffs'`
`'chmod +x bin/rake'`

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/../app/models/*.rb') { |file| require file }
