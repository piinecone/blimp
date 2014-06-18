module Blimp
  module Status
    def self.run!
      system('git status -b -s --ignored')
      puts "Determining last SHA for storage location..."
      value = `git rev-parse --verify HEAD`
      if $?.exitstatus == 0
        puts "Assets for #{value} will be stored at internet.com:/#{value}"
      else
        puts "Could not determine a SHA. Please commit something with git!"
      end
    end
  end
end
