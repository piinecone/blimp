require 'digest'

module Blimp
  module Utils
    def self.file_and_object_match?(filepath, object)
      # TODO fix this so it works identically on OS X and Windows
      object.exists? && object.etag.gsub(/"/, '') == Digest::MD5.hexdigest(File.open(filepath, 'rb') {|f| f.read})
      # object.exists? && object.content_length == File.stat(filepath).size
    end
  end
end
