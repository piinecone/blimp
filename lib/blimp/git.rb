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
          puts "Assets for commit #{sha} will be stored in #{Blimp::S3.hostname}/#{Blimp::S3.bucket_name}/#{Blimp.project_root}/#{sha}"
        when 'push'
          puts "Pushing assets for commit #{sha} to #{Blimp::S3.hostname}/#{Blimp::S3.bucket_name}/#{Blimp.project_root}/#{sha}"
        when 'pull'
          puts "Fetching assets for commit #{sha} from #{Blimp::S3.hostname}/#{Blimp::S3.bucket_name}/#{Blimp.project_root}/#{sha}"
        end
      else
        puts "Could not get a SHA. Please commit something!"
      end

      sha
    end

    def self.sha_before(sha)
      values = `git rev-list --all`
      values = values.split("\n").map{|v| v[0..6]}
      index = values.index(sha) + 1
      if values.count > index
        values[index]
      else
        puts "No more SHAs remaining. Someone needs to `blimp push` something!"
        exit
      end
    end
  end
end
