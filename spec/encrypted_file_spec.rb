require "spec_helper"

module OoxmlDecrypt
  RSpec.describe EncryptedFile do
    it "should decrypt an encrypted XLSX" do
      password = "p\0a\0s\0s\0w\0o\0r\0d\0"
      filename = "spec/examples/password.xlsx"
      plaintext = EncryptedFile.decrypt(filename, password)

      expect(plaintext[0,16].hexify).to eql("504b0304140006000800000021009745")
      expect(plaintext[-16,16].hexify).to eql("0000090009003e020000731b00000000")

      expected_plaintext = File.read("spec/examples/password.xlsx_decrypted", :encoding => "binary")
      expect(plaintext.hexify).to eql(expected_plaintext.hexify)
    end
  end
end
