require 'aws'

module Blimp
  module S3
    HOST = 'https://s3.amazonaws.com'

    def self.s3
      @s3 ||= AWS::S3.new
    end

    def self.hostname
      HOST
    end

    def self.default_bucket_name
      '<s3_bucket_name>'
    end

    def self.bucket_name
      @bucket_name ||= `git config blimp.bucket`.chomp
    end

    def self.bucket
      @bucket ||= find_or_create_bucket
    end

    def self.find_or_create_bucket
      if s3.buckets.map(&:name).include?(bucket_name)
        s3.buckets[bucket_name]
      else
        s3.buckets.create(bucket_name)
      end
    end

    def self.whoami
      puts "AWS access key id: #{ENV['AWS_ACCESS_KEY_ID']}"
      puts "AWS secret key:    #{ENV['AWS_SECRET_ACCESS_KEY']}"
      puts "AWS bucket:        #{bucket_name}"
      puts "AWS project root:  #{bucket_name}/#{Blimp.project_root}/"
      if Blimp::S3.bucket_name == Blimp::S3.default_bucket_name
        puts "\nIMPORTANT: please update your Blimp bucket name in .git/config\n\n"
      end
    end
  end
end
