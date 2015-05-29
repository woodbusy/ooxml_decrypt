require "ooxml_decrypt/key_info_base"

module OoxmlDecrypt
  class KeyData < KeyInfoBase
    # Integrity-verification constants (not currently used)
    ENCRYPTED_DATA_INTEGRITY_SALT_BLOCK_KEY = "5FB2AD010CB9E1F6".unhexify
    ENCRYPTED_DATA_INTEGRITY_HMAC_VALUE_BLOCK_KEY = "A0677F02B22C8433".unhexify

    # Extracts key data parameters from the given XML document and populates a
    # new KeyData object.
    # @param [Nokogiri::XML::Document] xml_doc The EncryptionInfo section of
    #   the encrypted document
    def self.from_xml(xml_doc)
      kd_node = xml_doc.at_css("keyData")
      opts = KeyInfoBase.opts_from_xml_node(kd_node)

      return self.new(opts)
    end

    # Decrypts the given encrypted package using the given key.
    # @param [String] encrypted_package The EncryptedPackage section of the
    #   encrypted document
    # @param [String] key Decryption key
    def decrypt_encrypted_package_stream(encrypted_package, key)
      # Get the length of the real data in the cleartext (which may be shorter
      # than the full decrypted ciphertext)
      final_length = encrypted_package[0,8].unpack("Q<").first
      # The rest of the encrypted package is the ciphertext
      ciphertext = encrypted_package[8..-1]

      chunk_size = 4096
      ciphertext_chunks = (0..(ciphertext.length-1)/chunk_size).map{|i| ciphertext[i*chunk_size, chunk_size]}

      plaintext = ""
      ciphertext_chunks.each_with_index do |ciphertext_chunk, index|
        iv = hash(@salt + [index].pack("V"))
        iv.pad_or_trim!(@block_size)

        plaintext += decrypt(ciphertext_chunk, key, iv)
      end

      return plaintext[0,final_length]
    end
  end
end

