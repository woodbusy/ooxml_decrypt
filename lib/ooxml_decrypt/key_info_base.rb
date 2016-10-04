require "openssl"
require "ooxml_decrypt/string_helpers"

module OoxmlDecrypt
  class KeyInfoBase
    def initialize(opts)
      @block_size = opts.delete(:block_size)
      @hash_algorithm = opts.delete(:hash_algorithm)
      @cipher_algorithm = opts.delete(:cipher_algorithm)
      @key_bits = opts.delete(:key_bits)
      @cipher_chaining = opts.delete(:cipher_chaining)
      @salt = opts.delete(:salt)

      raise "Unknown opts: #{opts.keys.join(',')}" if opts.any?
    end

    # Parses options that KeyInfoBase knows about from an XML node. (Helper
    # function to be used by initializers in subclasses).
    # @param [Nokogiri::XML::Node] xml_node
    def self.opts_from_xml_node(xml_node)
      opts = {
        :block_size => xml_node["blockSize"].to_i,
        :hash_algorithm => xml_node["hashAlgorithm"],
        :cipher_algorithm => xml_node["cipherAlgorithm"],
        :key_bits => xml_node["keyBits"].to_i,
        :cipher_chaining => xml_node["cipherChaining"],
        :salt => xml_node["saltValue"].base64_decode,
      }
    end

    def hash(value)
      case @hash_algorithm
      when "SHA1"
        Digest::SHA1.digest(value)
      when "SHA512"
        Digest::SHA512.digest(value)
      else
        raise "Unsupported hash algorithm: #{@hash_algorithm}"
      end
    end
    protected :hash

    def cipher(key, iv)
      cipher_string = ""
      case @cipher_algorithm
      when "AES"
        cipher_string += "aes"
      else
        raise "Unsupported cipher algorithm: #{@cipher_algorithm}"
      end

      cipher_string += "-#{@key_bits}"

      case @cipher_chaining
      when "ChainingModeCBC"
        cipher_string += "-cbc"
      else
        raise "Unsupported chaining: #{@cipher_chaining}"
      end

      cipher = OpenSSL::Cipher.new(cipher_string)
      cipher.key = key
      cipher.iv = iv
      cipher.padding = 0

      return cipher
    end
    protected :cipher

    def decrypt(ciphertext, key, iv=@salt)
      cipher = cipher(key, iv)
      return cipher.update(ciphertext) + cipher.final
    end
    protected :decrypt
  end
end
