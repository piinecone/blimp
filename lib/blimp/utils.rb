module Blimp
  module Utils
    def self.file_and_object_match?(filepath, object)
      object.exists? &&
        File.stat(filepath).mtime <= object.last_modified &&
        object.content_length == File.stat(filepath).size
    end
  end
end
