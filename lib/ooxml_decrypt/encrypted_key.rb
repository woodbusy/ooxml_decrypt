require "ooxml_decrypt/key_info_base"

module OoxmlDecrypt
  class EncryptedKey < KeyInfoBase
    # Integrity-verification constants (not currently used)
    ENCRYPTED_VERIFIER_HASH_INPUT_BLOCK_KEY = "FEA7D2763B4B9E79".unhexify
    ENCRYPTED_VERIFIER_HASH_VALUE_BLOCK_KEY = "D7AA0F6D3061344E".unhexify
    # Static key used in decrypting the key-encryption key
    ENCRYPTED_KEY_VALUE_BLOCK_KEY = "146E0BE7ABACD0D6".unhexify

    def initialize(opts)
      @spin_count = opts.delete(:spin_count)
      @encrypted_key = opts.delete(:encrypted_key)
      super(opts)
    end

    # Extracts key-encryption-key data parameters from the given XML document
    # and populates a new EncryptedKey object.
    # @param [Nokogiri::XML::Document] xml_doc The EncryptionInfo section of
    #   the encrypted OOXML document
    def self.from_xml(xml_doc)
      ke_node = xml_doc.at_css("keyEncryptor")
      raise "Expected only one child for keyEncryptor" unless ke_node.children.count == 1

      ek_node = ke_node.child
      opts = KeyInfoBase.opts_from_xml_node(ek_node)
      opts[:spin_count] = ek_node["spinCount"].to_i
      opts[:encrypted_key] = ek_node["encryptedKeyValue"].base64_decode

      return self.new(opts)
    end

    def key_encryption_key( password )
      temp = hash( @salt + password )
      @spin_count.times do |itr|
        temp = hash( [itr].pack("V") + temp )
      end

      temp = hash(temp + ENCRYPTED_KEY_VALUE_BLOCK_KEY)
      temp.pad_or_trim!( @block_size )
    end
    private :key_encryption_key

    # Decrypts the key-encryption key using the given password
    # @param [String] password Password as a UTF-16-formatted binary string
    #   (e.g. the password 'password' should be passed as "p\0a\0s\0s\0w\0r\0d\0")
    # @return [String] The key-encryption key
    def key(password)
      decrypt(@encrypted_key, key_encryption_key(password))
    end
  end
end

