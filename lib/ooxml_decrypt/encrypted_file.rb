require "ole/storage"
require "nokogiri"

module OoxmlDecrypt
  class EncryptedFile
    # @param [String] filename Path to the encrypted OOXML file
    def initialize(filename)
      @ole = Ole::Storage.open(filename)
      unless @ole.dir.entries(".").include?("EncryptionInfo") and
          @ole.dir.entries(".").include?("EncryptedPackage")
        raise "File does not appear to be an encrypted Office document"
      end
    end

    # The EncryptionInfo section of the file, as an XML doc
    # @return [Nokogiri::XML::Document]
    def encryption_info
      if @ei_xml.nil?
        ei_text = @ole.file.read("EncryptionInfo")
        v_major, v_minor, flags = ei_text[0,8].unpack("vvV")
        unless v_major == 4 && v_minor == 4
          raise "Unsupported encryption version"
        end
        unless flags == 0x40
          raise "Unsupported encryption algorithm"
        end

        @ei_xml = Nokogiri::XML( ei_text[8..-1] )
      end

      return @ei_xml
    end
    private :encryption_info

    def key_data
      if @key_data.nil?
        @key_data = KeyData.from_xml(encryption_info)
      end

      return @key_data
    end
    private :key_data

    def encrypted_key
      if @encrypted_key.nil?
        @encrypted_key =  EncryptedKey.from_xml(encryption_info)
      end

      return @encrypted_key
    end
    private :encrypted_key

    def encrypted_package
     @ole.file.read("EncryptedPackage")
    end
    private :encrypted_package

    # Decrypts this encrypted file using the given password
    # @param [String] password Password as a UTF-16-formatted binary string
    #   (e.g. the password 'password' should be passed as "p\0a\0s\0s\0w\0r\0d\0")
    # @return [String] The decrypted file
    def decrypt(password)
      decryption_key = encrypted_key.key(password)
      return key_data.decrypt_encrypted_package_stream( encrypted_package, decryption_key )
    end

    # Decrypts the given file using the given password
    # @param [String] filename Path to the encrypted OOXML file
    # @param [String] password Password as a UTF-16-formatted binary string
    #   (e.g. the password 'password' should be passed as "p\0a\0s\0s\0w\0r\0d\0")
    def self.decrypt(filename, password)
      encrypted_file = EncryptedFile.new(filename)
      return encrypted_file.decrypt(password)
    end

    # Decrypts the given file using the given password and writes the result to
    # a second file
    # @param [String] enc_filename Path to the encrypted OOXML file
    # @param [String] password Password as a UTF-16-formatted binary string
    #   (e.g. the password 'password' should be passed as "p\0a\0s\0s\0w\0r\0d\0")
    # @param [String] dec_filename Path to the decrypted output file. If a file
    #   exists at this path, it will be overwritten.
    def self.decrypt_to_file(enc_filename, password, dec_filename)
      plaintext = decrypt(enc_filename, password)
      File.open(dec_filename, "wb") {|file| file.write(plaintext)}
    end
  end
end
