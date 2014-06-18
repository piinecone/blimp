module Blimp
  def self.project_root
    File.basename(Dir.getwd).downcase
  end

  module Application
    def self.run!
      cmd = ARGV.shift

      if cmd != 'init' && `git config blimp.bucket`.empty?
        puts "Please run `blimp init` from within a git repo."
        exit
      end

      case cmd
        when 'watch'
          require 'blimp/watch'
          Blimp::Watch.run!
        when 'push'
          require 'blimp/push'
          Blimp::Push.run!
        when 'pull'
          require 'blimp/pull'
          Blimp::Pull.run!
        when 'status'
          require 'blimp/status'
          Blimp::Status.run!
        when 'unwatch'
          require 'blimp/unwatch'
          Blimp::Unwatch.run!
        when 'init'
          require 'blimp/init'
          Blimp::Init.run!
        when 'whoami'
          require 'blimp/s3'
          Blimp::S3.whoami
        else
          print <<EOF
usage: blimp status|watch|unwatch|push|pull|config

   init
   status
   watch
   push
   pull

EOF
      end
    end
  end
end

