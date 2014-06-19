require 'digest'

module Blimp
  module Utils
    def self.file_and_object_match?(filepath, object)
      object.exists? && object.etag.gsub(/"/, '') == Digest::MD5.hexdigest(File.read(filepath))
    end
  end
end
