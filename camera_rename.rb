#! /usr/bin/env ruby
class CameraRename
  def self.directory_to_yymmdd(fullpath_dir)
    yy = (File.mtime fullpath_dir).strftime('%y')

    parent_dir, dir_name = File.split(fullpath_dir)
    mmdd = dir_name.match(self.regex_dir_to_mmdd).to_a[1]
    return unless mmdd

    new_dir = File.join(parent_dir, "#{yy}#{mmdd}")
    puts "#{dir_name} => #{yy}#{mmdd}"
    if File.exist? new_dir
      puts "#{new_dir} is exist"
      sleep 1
      time = Time.now.strftime("%m%d%H%M%S")
      File.rename(fullpath_dir, "#{new_dir}_#{time}")
    else
      File.rename(fullpath_dir, new_dir)
    end
  end

  def self.rename(fullpath_dir_or_parent_dir)
    fail "#{fullpath_dir_or_parent_dir} is not a directory" unless File.directory? fullpath_dir_or_parent_dir

    target_dirs = Dir.entries(fullpath_dir_or_parent_dir)[2..].map do |ele|
      fullpath = File.join(fullpath_dir_or_parent_dir, ele)
      next unless File.directory? fullpath
      fullpath
    end.append(fullpath_dir_or_parent_dir).compact

    p "target #{target_dirs.count} directories."

    target_dirs.each do |entry|
      self.directory_to_yymmdd(entry)
    end
  end
end

class PentaxCameraRename < CameraRename
  def self.regex_dir_to_mmdd
    /^\d{3}_(\d{4}.*)$/
  end
end

class SonyCameraRename < CameraRename
  def self.regex_dir_to_mmdd
    /^\d{4}(\d{4}.*)$/
  end
end

def camera_rename(fullpath_dir_or_parent_dir, maker)
  maker ||= 'sony'
  klass = "#{maker.to_s.capitalize}CameraRename"
  Object.const_get(klass).rename(fullpath_dir_or_parent_dir)
end


if __FILE__ == $0
  camera_rename ARGV[0], ARGV[1]
end
