require 'blimp/git'
require 'blimp/s3'
require 'fileutils'
require 'blimp/utils'

module Blimp
  module Pull
    def self.run!
      # do not overwrite local files unless the -f option is used
      puts "HEAD is at #{current_sha}"
      fetch_from_remote_for current_sha
    end

    private

    def self.fetch_from_remote_for(sha)
      puts "Fetching assets from #{remote(sha)}".cyan
      objects = s3.bucket.objects.with_prefix(remote(sha))
      if objects.count == 0
        puts "Error: there are no files available on the remote for #{sha}."
        puts "Would you like to download files from the previous SHA? [y/n]".red
        response = gets.chomp
        if response == 'y'
          sha = Blimp::Git.sha_before(sha)
          if !sha.empty?
            fetch_from_remote_for sha
          else
            puts "No more SHAs remaining. Someone needs to #{'`blimp push`'.light_blue} something!"
            exit
          end
        else
          puts "Please run `blimp push` for #{sha}. Exiting...".cyan
          exit
        end
      else
        objects.each_with_index do |object, index|
          local_key = local_key_for_object(object, sha)
          progress = "(#{index+1}/#{objects.count})".yellow
          puts "#{progress} Downloading #{object.key.light_blue}"
          download object, local_key
        end
        puts "Downloaded #{objects.count} objects.".green
      end
    end

    def self.download(object, path)
      if File.exists?(path)
        if File.mtime(path) > object.last_modified
          response = user_wants_to_overwrite_local_copy? path
          if response == 'y'
            write_object_to_path object, path
          else
            puts "Skipping #{object.key}. Push, delete, or move this file and `blimp pull` to resynchronize."
          end
        elsif Blimp::Utils.file_and_object_match?(path, object)
          puts "Your local is up to date, skipping...".black
          return
        end
      else
        write_object_to_path object, path
      end
    end

    def self.write_object_to_path(object, path)
      dir = path.gsub(path.split("/").last, '')
      FileUtils.mkdir_p(dir)
      File.open(path, 'wb') do |f|
        s3.core.get_object({bucket: s3.bucket_name, key: object.key}, target: path)
      end
    end

    def self.user_wants_to_overwrite_local_copy?(path)
      puts "Warning: #{path} exists".red
      puts "Your local version of this file is more recent. Do you want to overwrite it?"
      puts "Overwrite #{path}? [y/n]".red

      gets.chomp
    end

    def self.remote(sha)
      "#{Blimp.project_root}/#{sha}"
    end

    def self.local_key_for_object(object, sha)
      "#{Dir.getwd}#{object.key.gsub(remote(sha), '')}"
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
