require 'aws'
require 'pry'

module Blimp
  module Push
    S3_HOST = 'https://s3.amazonaws.com'
    BUCKET_NAME = 'piinecone'

    def self.run!
      puts 'Running blimp push...'
      # find SHA for push
      dir_name = head_sha
      unless dir_name.empty?
        # gather file paths to upload
        filepaths = gather_filepaths
        begin
          filepaths.each_with_index do |filepath, index|
            puts "(#{index+1}/#{filepaths.count})"
            key = "#{project_root}/#{dir_name}/#{filepath}"
            puts "Preparing to create #{key} remotely..."
            if bucket.objects[key].exists?
              puts "Warning: #{key} exists, skipping upload. Create a new commit if you want to upload this file."
            else
              puts "Creating #{S3_HOST}/#{BUCKET_NAME}/#{key}"
              bucket.objects[key].write(file: filepath)
            end
          end
        end
      end
    end

    private

    def self.project_root
      File.basename Dir.getwd
    end

    def self.directory_exists?(dir_name)
      puts bucket.objects[dir_name]
    end

    def self.whoami
        puts ENV['AWS_ACCESS_KEY_ID']
        puts ENV['AWS_SECRET_ACCESS_KEY']
        puts s3.buckets.map(&:name)
    end

    def self.s3
      @s3 ||= AWS::S3.new
    end

    def self.bucket
      @bucket ||= find_or_create_bucket(BUCKET_NAME)
    end
    
    def self.find_or_create_bucket(name)
      if s3.buckets.map(&:name).include?(name)
        s3.buckets[name]
      else
        s3.buckets.create(name)
      end
    end

    def self.head_sha
      value = `git rev-parse --verify HEAD`
      if $?.exitstatus == 0
        puts "Assets for #{value} will be stored at internet.com:/#{value}"
      else
        puts "Could not determine a SHA. Please commit something with git!"
      end
      value.gsub!('\n', '')
      value.gsub!('\t', '')
      value.gsub!('\r', '')
      value.gsub!(/\s+/, '')
      value
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
