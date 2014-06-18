require 'fileutils'

module Blimp
  module Watch
    def self.run!
      puts 'Running blimp watch...'
      patterns = ARGV
      gitignore_watched_files patterns
      start_watching patterns
      puts 'Done!'
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
        puts "Adding #{pattern} to #{filename}"
        unless file_contains_line?(filename, pattern)
          File.open(filename, 'a') do |file|
            file.puts pattern
          end
        end
      end
    end

    # TODO make this actually work
    def self.file_contains_line?(filename, match)
      File.open(filename).each do |line|
        # puts line =~ /\#{match}/
        return true if line =~ /\#{match}/
      end
      false
    end
  end
end
