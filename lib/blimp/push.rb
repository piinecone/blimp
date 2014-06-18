require 'blimp/s3'
require 'blimp/git'

module Blimp
  module Push
    def self.run!
      puts 'Running blimp push...'
      dir_name = current_sha
      unless dir_name.empty?
        # gather file paths to upload
        filepaths = gather_filepaths
        begin
          filepaths.each_with_index do |filepath, index|
            puts "(#{index+1}/#{filepaths.count})"
            key = "#{Blimp.project_root}/#{dir_name}/#{filepath}"
            puts "Preparing to create #{s3.hostname}/#{s3.bucket_name}/#{key}..."
            if bucket.objects[key].exists?
              puts "Warning: #{key} exists, skipping upload. Create a new commit if you want to upload this file."
            else
              puts "Creating #{s3.hostname}/#{s3.bucket_name}/#{key}"
              bucket.objects[key].write(file: filepath)
            end
          end
        end
      end
    end

    private

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
      git.current_sha
    end

    def self.gather_filepaths
      paths = []
      patterns.each do |pattern|
        extension = pattern.partition('.').last
        match = "**/*.#{extension}"
        paths << Dir[match]
      end

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
