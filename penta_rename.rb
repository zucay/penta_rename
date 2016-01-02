#! /usr/bin/env ruby
def penta_name_to_yymmdd(fullpath_dir)
  fail "#{fullpath_dir} is not a directory" unless File.directory? fullpath_dir
  yy = (File.mtime fullpath_dir).strftime('%y')
  parent_dir, dir_name = File.split(fullpath_dir)
  mmdd = dir_name.match(/^\d{3}_(\d{4}.*)/)[1]
  new_dir = File.join(parent_dir, "#{yy}#{mmdd}")

  puts "#{dir_name} => #{yy}#{mmdd}"
  if File.exist? new_dir
    puts "#{new_dir} is exist"
  else
    File.rename(fullpath_dir, new_dir)
  end
end

def penta_rename(fullpath_dir_or_parent_dir)
  fail "#{fullpath_dir_or_parent_dir} is not a directory" unless File.directory? fullpath_dir_or_parent_dir
  Dir.entries(fullpath_dir_or_parent_dir).select {|ent| ent =~ /^\d{3}_\d{4}/}.each do |entry|
    path = File.join(fullpath_dir_or_parent_dir, entry)
    penta_name_to_yymmdd(path) if File.directory? path
  end
end

if __FILE__ == $0
  penta_rename ARGV[0]
end
