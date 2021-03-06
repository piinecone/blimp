require 'blimp/color'

module Blimp
  def self.project_root
    if `git config blimp.folder`.empty?
      File.basename(Dir.getwd).downcase
    else
      `git config blimp.folder`.chomp.downcase
    end
  end

  module Application
    def self.run!
      unless File.directory?('.git')
        puts "Please run `blimp` from the project's root directory."
        exit
      end

      cmd = ARGV.shift

      if cmd != 'init' && `git config blimp.bucket`.empty?
        puts "Please run #{'`blimp init`'.light_blue} from within a git repo."
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

