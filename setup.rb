# coding: utf-8
require 'json'
require 'pathname'
require 'git'

def init()
  json_file = File.read "config.json"
  options = JSON.parse(json_file)
  @install_command = options['install_command']
  puts "Command: #{@install_command}"
  @dir = options['dotfiles_location']
  puts "Dotfile Location: #{@dir}"
  @homedir = options['home_dir']
  puts "Home Dir: #{@homedir}"
  puts "==============="
  create_dir("Software")
  create_dir("Projects")
end

def setup_zsh()
  install_package("util-linux-user")
  install_package("zsh")
  %x{ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" }
  %x{ chsh -s /bin/zsh }
  %x{ cp #{@dir}/.zshrc #{@homedir} }
end

def setup_emacs()
  install_package("emacs")
end

def setup_bspwm()
  create_dir("Pictures/Screenshots")
  git_clone "https://github.com/baskerville/bspwm.git", "bspwm"
  git_clone "https://github.com/baskerville/sxhkd.git", "sxhkd"
  Dir.chdir("#{@homedir}/Software/bspwm"){
      %x{ make }
      %x{ sudo make install }
  }
  puts "[✔] bspwm építve"
  %x{ cp #{@dir}/bspwmrc #{@homedir}/.config/bspwmrc }
  %x{ chmod +x #{@homedir}/.config/bspwmrc}
  
  Dir.chdir("#{@homedir}/Software/sxhkd"){
      %x{ make }
      %x{ sudo make install }
  }
  %x{ cp #{@dir}/sxhkdrc #{@homedir}/.config/sxhkdrc }
  %x{ chmod +x #{@homedir}/.config/sxhkdrc }
  puts "[✔] sxhkd építve"
end

def git_clone(url, name)
  if Pathname.new("/#{@homedir}/Software/#{name}").exist?
    puts "[!] Git repo #{name} már van"
  else
    Git.clone url, "/#{@homedir}/Software/#{name}"
    puts "[✔] Git repo #{name} letöltve!"
  end
end

def create_dir(path, dir = @homedir)
  if Pathname.new("#{dir}/#{path}").exist?
    puts "[!] #{path} mappa már van!"
  else
    %x{mkdir #{dir}/#{path}}
    puts "[✔] #{path} mappa elkészült"
  end
end

def install_packages()
  File.open("packages", "r").each_line{ |l|
    install_package(l)
  }
end

def install_package(package_name)
  cmd = "#{@install_command} #{package_name}"
  puts "[i] #{package_name} telepítése"
  msg = %x{ #{cmd} }
  puts "[✔] #{package_name} telepítve"
end

init()
#install_packages
#setup_zsh
#setup_emacs
setup_bspwm
puts "Kész!"
