require 'blimp/s3'
require 'blimp/git'
require 'blimp/utils'

module Blimp
  module Push
    def self.run!
      dir_name = current_sha
      unless dir_name.empty?
        # gather file paths to upload
        filepaths = gather_filepaths
        if filepaths.empty?
          puts "Nothing to do! Run `blimp watch *.file_extension` to add files to blimp."
        else
          filepaths.each_with_index do |filepath, index|
            progress = "(#{index+1}/#{filepaths.count})".yellow
            key = "#{Blimp.project_root}/#{dir_name}/#{filepath}"
            if Blimp::Utils.file_and_object_match?(filepath, bucket.objects[key])
              puts "#{progress} #{key.blue} exists exactly, skipping upload. Create a new commit if you want to upload this file.'"
            else
              puts "#{progress} Uploading #{s3.hostname.light_blue}/#{s3.bucket_name.light_blue}/#{key.light_blue}"
              upload_object key, filepath
            end
          end
        end
      end
    end

    private

    def self.upload_object(key, filepath)
      # check if this exact object exists remotely
      previous_sha = Blimp::Git.sha_before(current_sha)
      while !previous_sha.empty?
        previous_key = "#{Blimp.project_root}/#{previous_sha}/#{filepath}"
        object = bucket.objects[previous_key]
        if Blimp::Utils.file_and_object_match?(filepath, object)
          puts "#{key} is unchanged; updating its location".black
          object.copy_to(key) # associate it with the current SHA
          return
        else
          previous_sha = Blimp::Git.sha_before(previous_sha)
        end
      end

      # this exact object doesn't exist at all remotely; upload it
      bucket.objects[key].write(file: filepath)
    end

    def self.s3
      @s3 ||= Blimp::S3
    end

    def self.bucket
      @bucket ||= s3.find_or_create_bucket
    end

    def self.git
      Blimp::Git
    end
    
    def self.current_sha
      @current_sha ||= git.current_sha('push')
    end

    def self.gather_filepaths
      paths = []
      patterns.each do |pattern|
        extension = pattern.partition('.').last
        match = "**/*.#{extension}"
        paths << Dir[match]
      end
      # TODO prune file paths matching .blimpignore patterns

      paths.flatten
    end

    def self.patterns
      if @patterns.nil?
        @patterns = []
        File.open('.blimp', 'r') do |file|
          file.each_line do |line|
            line.gsub!('\n', '')
            line.gsub!('\t', '')
            line.gsub!('\r', '')
            line.gsub!(/\s+/, '')
            @patterns << line
          end
        end
      end

      @patterns
    end
  end
end
