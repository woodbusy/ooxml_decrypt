require "spec_helper"

module OoxmlDecrypt
  RSpec.describe "When testing decryption" do
    let(:encrypted_key) do
      EncryptedKey.new( :spin_count => 100_000,
                        :block_size => 16,
                        :key_bits => 128,
                        :cipher_algorithm => "AES",
                        :cipher_chaining => "ChainingModeCBC",
                        :hash_algorithm => "SHA1",
                        :salt => "oksWUymFqdISO4t7krYTMQ==".base64_decode,
                        :encrypted_key => "7fHCMYen4j6VmJtYiuoKdA==".base64_decode,
                      )
    end
    let(:key_data) do
      KeyData.new(  :block_size => 16,
                    :key_bits => 128,
                    :cipher_algorithm => "AES",
                    :cipher_chaining => "ChainingModeCBC",
                    :hash_algorithm => "SHA1",
                    :salt => "O/HT8XgDoXnw+k9ts0Esxw==".base64_decode,
                  )
    end
    let(:password) { "p\0a\0s\0s\0w\0o\0r\0d\0" }

#    it "should generate a key-decryption key" do
#      key_encryption_key = encrypted_key.key_encryption_key(password)
#      expect( key_encryption_key.hexify ).to eql("1a1f6755f5a4f216023707fa3c986502")
#    end

    it "should decrypt a symmetric key" do
      expect( encrypted_key.key(password).hexify ).to eql("c965e405bc4183399e038d3784d26f93")
    end

    it "should decrypt an entire encrypted package stream" do
      encrypted_package = File.read("spec/examples/password.encrypted_package", :encoding => 'binary')
      plaintext = key_data.decrypt_encrypted_package_stream( encrypted_package, encrypted_key.key(password) )
      expect(plaintext[0,16].hexify).to eql("504b0304140006000800000021009745")
      expect(plaintext[-16,16].hexify).to eql("0000090009003e020000731b00000000")

      expected_plaintext = File.read("spec/examples/password.xlsx_decrypted", :encoding => "binary")
      expect(plaintext.hexify).to eql(expected_plaintext.hexify)
    end
  end
end
