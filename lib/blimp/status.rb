require 'blimp/git'

module Blimp
  module Status
    def self.run!
      system('git status -b -s --ignored')
      git.current_sha
    end

    private

    def self.git
      Blimp::Git
    end
  end
end
