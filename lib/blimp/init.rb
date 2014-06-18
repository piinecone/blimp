module Blimp
  module Init
    def self.run!
      if File.exists?('.git/config')
        File.open('.git/config', 'a') do |file|
          file << "[blimp]\n"
          file << "        bucket = s3_bucket_name\n"
        end
      else
        puts "Please run `git init` before `blimp init`"
      end
    end
  end
end
