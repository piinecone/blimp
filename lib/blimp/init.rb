require 'blimp/s3'

module Blimp
  module Init
    def self.run!
      unless File.exists?('.git/config')
        puts "Please run `git init` before `blimp init`."
        exit
      end

      if File.exists?('.git/config') && `git config blimp.bucket`.empty?
        File.open('.git/config', 'a') do |file|
          file << "[blimp]\n"
          file << "    bucket = #{Blimp::S3.default_bucket_name}\n"
        end
        puts "Your .git/config file has been modified."
      end

      unless File.exists?('.blimp')
        File.open('.blimp', 'w') do |file|
          file << "# Welcome to Blimp!\n\n"
          file << "# - Use `blimp watch *.big_file_extension` to tell blimp about big files\n"
          file << "# - Blimp will add the pattern to this file, like this:\n"
          file << "#   *.big_file_extension\n"
          file << "# - Blimp will also add that same pattern to your .gitignore.\n"
          file << "# - Files matching the patterns in .blimp will be stored in the s3 bucket specified by your .git/config\n\n"
          file << "# For example:\n"
          file << "# *.big_file_extension\n"
          file << "# *.some_other_big_file_extension\n\n"
        end
        puts "Your .blimp file has been created."
      end

      puts 'Blimp initialized'
      puts "\nWelcome to Blimp!"
      puts "----------------------------------------------------------------------"
      puts "- Use `blimp watch *.big_file_extension` to tell blimp about big files"
      puts "- Blimp will then add the pattern to the .blimp file, like this:"
      puts "  *.big_file_extension"
      puts "- Blimp will also add that same pattern to your .gitignore so you don't accidentally commit them"
      puts "- Files that match the patterns in .blimp will be pushed and pulled to and from the S3 bucket"
      puts "  specified in your .git/config"
      puts "\nYour current configuration:"
      puts "----------------------------------------------------------------------"
      Blimp::S3.whoami
      puts "\n"
    end
  end
end
