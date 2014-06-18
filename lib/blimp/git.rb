require 'blimp/s3'

module Blimp
  module Git
    def self.current_sha
      sha = `git rev-parse --verify HEAD`
      if $?.exitstatus == 0
        sha = sha[0..6]
        sha.gsub!('\n', '')
        sha.gsub!('\t', '')
        sha.gsub!('\r', '')
        sha.gsub!(/\s+/, '')
        puts "Assets for commit #{sha} will be stored in #{Blimp::S3.hostname}/#{Blimp::S3.bucket_name}/#{Blimp.project_root}/#{sha}"
      else
        puts "Could not get a SHA. Please commit something!"
      end

      sha
    end
  end
end
