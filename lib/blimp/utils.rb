require 'digest'

module Blimp
  module Utils
    def self.file_and_object_match?(filepath, object)
      # object.exists? && object.etag.gsub(/"/, '') == Digest::MD5.hexdigest(File.read(filepath))
      object.exists? && object.content_length == File.stat(filepath).size
    end
  end
end
