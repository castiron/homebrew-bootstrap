#!/usr/bin/env ruby
# Generates and installs a project nginx configuration using erb.
require "erb"
require "pathname"

root_configuration = ARGV.delete "--root"
if root_configuration
  http_port = 80
  https_port = 443
else
  http_port = 8080
  https_port = 8443
end

brew_dir = `brew --prefix`.strip
puts "Home brew is in #{brew_dir}"

name = ARGV.shift
root = ARGV.shift || "."
input = ARGV.shift || "config/dev/nginx.conf.erb"
if !name || !root || !input
  abort "Usage: brew setup-nginx-conf [--root] [--extra-val=variable=value] <project_name> <project_root_path> <nginx.conf.erb>"
end

# Default variables
tld = "lvh"

puts "===> Setting up nginx domain"

# Confirm that we have an ERB template
abort "Error: #{input} is not a .erb file!" unless input.end_with? ".erb"
root = File.expand_path root
input = File.expand_path input

# Find extra variables in the form of --extra-val=variable=value
# Using a hash and ERB#result_with_hash would be nice, but it didn't
# appear until Ruby 2.5. :/
variables = binding
ARGV.delete_if do |argument|
  next unless argument.start_with? "--extra-val="
  variable, value = argument.sub(/^--extra-val=/, "").split("=", 2)
  variables.local_variable_set(variable.to_sym, value)
  true
end

# Derived variables
server_name = "#{name}.#{tld}"
puts "===> Server name is #{server_name}"

data = IO.read input
conf = ERB.new(data).result(variables)
output = input.sub(/.erb$/, "")
output.sub!(/.conf$/, ".root.conf") if root_configuration
puts "===> Writing nginx conf to #{output}"
IO.write output, conf

exit if root_configuration

/access_log (?<log>.+);/ =~ conf
if log
  log = Pathname(log.split(" ").first)
  log.dirname.mkpath
  puts "===> Touching log at #{log}"
  FileUtils.touch log unless log.exist?
end

exit unless RUBY_PLATFORM.include? "darwin"

strap_url = ENV["HOMEBREW_STRAP_URL"]
strap_url ||= "https://strap.githubapp.com"

unless File.exist? "#{brew_dir}/bin/brew"
  abort <<~EOS
    Error: Homebrew is not installed. Install it.
EOS
end

brewfile = <<~EOS
  brew "nginx", restart_service: true
  brew "ciclaunchdns", restart_service: true
EOS

started_services = false
unless system "echo '#{brewfile}' | brew bundle check --file=- >/dev/null"
  puts "Installing *.#{tld} dependencies."
  system "brew install nginx"
  system "brew install launchdns"
  started_services = true
end

# Doing this in the ciclaunchdns formula now.
# unless File.exist? "#{brew_dir}/etc/resolver/#{tld}"
#   puts "Adding .#{tld} domain resolver; you may need to restart your network interface."
#   resolver = <<~EOS
#     nameserver 127.0.0.1
#     port 55353
#   EOS
#   File.write("#{brew_dir}/etc/resolver/#{tld}", resolver)
# end

if `readlink /etc/resolver 2>/dev/null`.chomp != "#{brew_dir}/etc/resolver"
  unless system "sudo -n true >/dev/null"
    puts "Asking for your password to setup *.#{tld}:"
  end
  system "sudo rm -rf /etc/resolver"
  unless system "sudo ln -sf #{brew_dir}/etc/resolver /etc/resolver"
    abort "Error: failed to symlink #{brew_dir}/etc/resolver to /etc/resolver!"
  end
end

if File.exist? "/etc/pf.anchors/dev.strap"
  unless system "sudo -n true >/dev/null"
    puts "Asking for your password to uninstall pf:"
  end
  system "sudo rm /etc/pf.anchors/dev.strap"
  system "sudo grep -v 'dev.strap' /etc/pf.conf | sudo tee /etc/pf.conf"
  system "sudo launchctl unload /Library/LaunchDaemons/dev.strap.pf.plist 2>/dev/null"
  system "sudo launchctl load -w /Library/LaunchDaemons/dev.strap.pf.plist 2>/dev/null"
  system "sudo launchctl unload /Library/LaunchDaemons/dev.strap.pf.plist 2>/dev/null"
  system "sudo rm -f /Library/LaunchDaemons/dev.strap.pf.plist"
end

server = "#{brew_dir}/etc/nginx/servers/#{name}"
unless system "ln -sf '#{File.absolute_path(output)}' '#{server}'"
  abort "Error: failed to symlink #{output} to #{server}!"
end

system "brew cleanup --prune-prefix >/dev/null"
unless started_services
  unless system "brew services restart nginx >/dev/null"
    abort "Error: failed to (re)start nginx!"
  end
end

system "brew ensure-nginx-executable"
