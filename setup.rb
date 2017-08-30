# coding: utf-8
require 'json'

def init()
  json_file = File.read "config.json"
  options = JSON.parse(json_file)
  @install_command = options['install_command']
  @dir = options['dotfiles_location']
end

def setup_zsh()
  install_package("zsh")
end

def setup_emacs()
  install_package("emacs")
end

def install_package(package_name)
  cmd = "#{@install_command} #{package_name}"
  puts "Installing #{package_name}"
  t = %x{ #{cmd} }
end

init()
setup_zsh
setup_emacs
puts "Kész!"
