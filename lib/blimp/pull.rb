require 'blimp/git'
require 'blimp/s3'

module Blimp
  module Pull
    def self.run!
      # do not overwrite local files unless the -f option is used
      puts "HEAD is at #{current_sha}"
      puts "Downloading assets from #{remote_prefix}"
      objects = s3.bucket.objects.with_prefix(remote_prefix)
      objects.each_with_index do |object, index|
        local_key = local_key_for_object(object)
        puts "(#{index+1}/#{objects.count}) Writing #{object.key} to #{local_key}..."
        download object, local_key
      end
    end

    private

    def self.download(object, path)
      if File.exists?(path)
        if File.mtime(path) > object.last_modified
          puts "--------------------------------------------------------------------------------------"
          puts "Warning: #{path}"
          puts "Your local version of this file is more recent. Are you sure you want to overwrite it?"
          puts "--------------------------------------------------------------------------------------"
          puts "Overwrite #{path}? [y/n]"
          response = gets.chomp
          if response == 'y'
            write_object_to_path object, path
          else
            puts "Skipping #{object.key}. Push, delete, or move this file and `blimp pull` to resynchronize."
          end
        end
      else
        write_object_to_path object, path
      end
    end

    def self.write_object_to_path(object, path)
      File.open(path, "w") do |f|
        f.write object.read
      end
    end

    def self.remote_prefix
      "#{Blimp.project_root}/#{current_sha}" 
    end

    def self.local_key_for_object(object)
      "#{Dir.getwd}#{object.key.gsub(remote_prefix, '')}"
    end

    def self.s3
      Blimp::S3
    end

    def self.git
      Blimp::Git
    end

    def self.current_sha
      @current_sha ||= git.current_sha
    end
  end
end
