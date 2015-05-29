module StringHelpers

  # Convert a string to ASCII hex string
  # (Adapted from the Ruby Black Bag [http://github.com/emonti/rbkb/])
  def hexify()
    out=Array.new
    hexchars = [("0".."9").to_a, ("a".."f").to_a].flatten

    self.each_byte do |c|
      hc = (hexchars[(c >> 4)] + hexchars[(c & 0xf )])
      out << (hc)
    end
    out.join("")
  end

  # Convert ASCII hex string to raw.
  # (Adapted from the Ruby Black Bag [http://github.com/emonti/rbkb/])
  # @param [Regex] d (Optional) 'delimiter' between hex bytes (zero+ spaces by default)
  def unhexify(d=/\s*/)
    self.strip.gsub(/([A-Fa-f0-9]{1,2})#{d}?/) { $1.hex.chr }
  end

  def base64_decode
    return self.unpack("m").first
  end

  # Makes the string a given length by trimming excess bytes from the endi, or
  # padding with the given padding byte.
  # @param [Integer] final_length
  # @pad_byte [String] pad_byte (Optional) A single-byte string (default is 0x36)
  def pad_or_trim!( final_length, pad_byte="\x36" )
    self.slice!(final_length..-1)
    self << pad_byte * (final_length - self.length)
    return self
  end
end

class String
  include StringHelpers
end
