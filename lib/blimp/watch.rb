require 'fileutils'

module Blimp
  module Watch
    def self.run!
      patterns = ARGV
      gitignore_watched_files patterns
      start_watching patterns
    end

    private

    def self.gitignore_watched_files(patterns)
      append_strings_to_file '.gitignore', patterns
    end

    def self.start_watching(patterns)
      append_strings_to_file '.blimp', patterns
    end

    def self.append_strings_to_file(filename, strings)
      File.exists?(filename) ? nil : File.new(filename, "w+")
      strings.each do |string|
        pattern = "*#{string.match(/\..+/)[0]}"
        if file_contains_line?(filename, pattern)
          puts "#{pattern} is already present in #{filename}"
        else
          File.open(filename, 'a') do |file|
            file.puts pattern
          end
          puts "Added #{pattern} to #{filename}"
        end
      end
    end

    def self.file_contains_line?(filename, match)
      File.open(filename).each do |line|
        return true if line.chomp == match
      end
      false
    end
  end
end
