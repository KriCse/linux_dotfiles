require 'json'

def init()
  json_file = File.read "config.json"
  options = JSON.parse(json_file)
  @install_command = options['install_command']
end

init()
puts @install_command

