module Blimp
  def self.project_root
    File.basename Dir.getwd
  end

  module Application
    def self.run!
      cmd = ARGV.shift
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
        when 'config'
          require 'blimp/config'
          Blimp::Config.run!
        else
           print <<EOF
usage: blimp status|watch|unwatch|push|pull|config

   status
   watch
   unwatch
   push
   pull
   config

EOF
      end
    end
  end
end

