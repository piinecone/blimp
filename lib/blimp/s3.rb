require 'aws'

module Blimp
  module S3
    HOST = 'https://s3.amazonaws.com'
    BUCKET_NAME = 'piinecone'

    def self.s3
      @s3 ||= AWS::S3.new
    end

    def self.hostname
      HOST
    end

    def self.bucketname
      BUCKET_NAME
    end

    def self.bucket
      @bucket ||= find_or_create_bucket
    end

    def self.find_or_create_bucket
      if s3.buckets.map(&:name).include?(BUCKET_NAME)
        s3.buckets[BUCKET_NAME]
      else
        s3.buckets.create(BUCKET_NAME)
      end
    end

    def self.whoami
      puts ENV['AWS_ACCESS_KEY_ID']
      puts ENV['AWS_SECRET_ACCESS_KEY']
      puts s3.buckets.map(&:name)
    end
  end
end
