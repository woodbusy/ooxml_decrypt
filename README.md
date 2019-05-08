# OoxmlDecrypt [![Build Status](https://travis-ci.org/woodbusy/ooxml_decrypt.svg?branch=master)](https://travis-ci.org/woodbusy/ooxml_decrypt)

A Ruby library and script for decrypting password-protected Microsoft Office XML files (.docx, .xlsx, etc.), which use the OOXML format. There are many tools available for working with OOXML files without Office, but a password-protected document typically requires an Office installation to decrypt. This pure-Ruby, standalone library and script can decrypt Office files without an Office installation.

At present, this only supports documents encrypted (i.e. password-protected) by Office 2010 or later. Office 2007 also uses XML, but the encryption settings are a bit different.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ooxml_decrypt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ooxml_decrypt

## Usage

### Command Line Tool

If you installed the gem using Bundler, execute:

    $ bundle exec ooxml_decrypt --source <path> --destination <path> --password <password>

otherwise use:

    $ ooxml_decrypt --source <path> --destination <path> --password <password>

### Within your code

To decrypt a file programatically:

```ruby
require 'ooxml_decrypt'

encrypted_path = ...
decrypted_path = ...
# Ensure password is a binary representation of a UTF-16LE string
binary_password = password.encode("utf-16le")
                          .bytes.pack("c*")
                          .encode("binary")

OoxmlDecrypt::EncryptedFile.decrypt_to_file(encrypted_path, binary_password, decrypted_path)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Pull requests welcome! Once you've forked and cloned the project, you can `bundle install` to take care of the dependencies; after that, you're ready to code.

You can also create issues for any bugs or feature requests, but they may take longer to get done, of course.


## TODO

- Support for Office 2007 documents
- Do verification (i.e. detect when password is incorrect)


## References

- Microsoft [MS-OFFCRYPTO](https://msdn.microsoft.com/en-us/library/office/cc313071)
- http://www.lyquidity.com/devblog/?p=35
- http://www.lyquidity.com/devblog/?p=85
