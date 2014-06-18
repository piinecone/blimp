require 'blimp/s3'

module Blimp
  module Git
    def self.current_sha
      sha = `git rev-parse --verify HEAD`
      if $?.exitstatus == 0
        sha.gsub!('\n', '')
        sha.gsub!('\t', '')
        sha.gsub!('\r', '')
        sha.gsub!(/\s+/, '')
        puts "Assets for HEAD will be stored under #{Blimp::S3.hostname}/#{Blimp::S3.bucket_name}/#{sha}"
      else
        puts "Could not get a SHA. Please commit something!"
      end

      sha
    end
  end
end
