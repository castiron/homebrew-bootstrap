#!/usr/bin/env ruby

require "pathname"
require "fileutils"
require "find"

type = ARGV.shift

if type.to_s.empty?
  abort "Usage: brew scaffold <type>"
end

tap_root = File.join(ENV["HOMEBREW_LIBRARY"], "Taps", "castiron", "homebrew-bootstrap")
template_dir = File.join(tap_root, "scaffold")
children = Pathname.new(template_dir).children
valid_types = children.select { |c| c.directory? }.collect { |p| p.basename.to_s }

unless valid_types.include? type
  abort "Invalid type. Valid types include: #{valid_types.join(", ")}"
end

if type == "rails"
  unless File.exists?("./Gemfile") && Dir.exists?("config") && Dir.exists?("app/models")
    abort "The current directory does not appear to be the root of a Rails project"
  end
end

if type == "october" || type =="docker_october"
  unless File.exists?("composer.json") && File.exists?("config/cms.php")
    abort "The current directory does not appear to be the root of a October project"
  end
end

if type == "docker_craft_next"
  unless File.exists?("api/composer.json") && File.exists?("client/package.json")
    abort "The current directory does not appear to be the root of a Craft/Next project"
  end
end


source_dir = File.join(template_dir, type)
source_root_path = Pathname.new(source_dir)
target_root_path = Pathname.pwd

all = false
Find.find(source_dir) do |path|
  source_path = Pathname.new path
  source_rel_path = source_path.relative_path_from source_root_path
  target_path = Pathname.new target_root_path + source_rel_path
  is_dir = File.directory?(source_path)
  source_string_path = source_rel_path.to_s
  next if source_string_path.end_with?(".") || source_string_path.end_with?(".DS_Store")
  if target_path.exist? && File.directory?(target_path)
    puts "exists #{target_path}"
    next
  end
  if File.exist?(target_path) && !all
    print "#{source_rel_path} exists. Overwrite? y/n/a: \e[0m"
    ok = gets.rstrip
    all = true if ok == "a"
    if ok != "y" && !all
      puts "skip   #{target_path}"
      next
    end
  end
  puts "create #{target_path}"
  if is_dir
    Dir.mkdir target_path
  else
    FileUtils.cp(source_path, target_path)
  end
end
