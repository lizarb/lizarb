class DevSystem::ZlibGemShell < DevSystem::GemShell
  require "zlib"

  # Computes the CRC32 checksum of the given object and returns it
  # as a lowercase hexadecimal string.
  #
  # @param string [Object] value to compute CRC32 for; converted to String via `to_s`.
  # @return [String] CRC32 checksum represented in hexadecimal (base 16).
  # @example
  #   ZlibGemShell.crc32("")      # => "0"
  #   ZlibGemShell.crc32("hello") # => "3610a686"
  #   ZlibGemShell.crc32("ruby")  # => "cc5add0d"
  def self.crc32(string) = ( call({}); Zlib.crc32(string.to_s).to_s(16) )

end
