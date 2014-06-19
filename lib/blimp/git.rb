require 'blimp/s3'

module Blimp
  module Git
    def self.current_sha(subcommand='status')
      sha = `git rev-parse --verify HEAD`
      if $?.exitstatus == 0
        sha = sha[0..6]
        sha.gsub!('\n', '')
        sha.gsub!('\t', '')
        sha.gsub!('\r', '')
        sha.gsub!(/\s+/, '')
        case subcommand
        when 'status'
          puts "Assets for commit #{emphasized_sha(sha)} will be stored in #{emphasized_path_for(sha)}"
        when 'push'
          puts "Pushing assets for commit #{emphasized_sha(sha)} to #{emphasized_path_for(sha)}"
        when 'pull'
          puts "Fetching assets for commit #{emphasized_sha(sha)} from #{emphasized_path_for(sha)}"
        end
        Blimp::S3.check_bucket
      else
        puts "Could not get a SHA. Please commit something!"
      end

      sha
    end

    def self.emphasized_sha(sha)
      sha.yellow
    end

    def self.emphasized_path_for(sha)
      "#{Blimp::S3.hostname.yellow}/#{Blimp::S3.bucket_name.yellow}/#{Blimp.project_root.yellow}/#{sha.yellow}"
    end

    def self.sha_before(sha)
      values = `git rev-list --all`
      values = values.split("\n").map{|v| v[0..6]}
      index = values.index(sha) + 1
      if values.count > index
        values[index]
      else
        return ""
      end
    end
  end
end
