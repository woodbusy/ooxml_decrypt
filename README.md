# ooxml_decrypt [![Build Status](https://travis-ci.org/woodbusy/ooxml_decrypt.svg?branch=master)](https://travis-ci.org/woodbusy/ooxml_decrypt)

A Ruby library and script for decrypting password-protected Microsoft Office XML files (.docx, .xlsx, etc.), which use the OOXML format. There are many tools available for working with OOXML files without Office, but a password-protected document typically requires an Office installation to decrypt. This pure-Ruby, standalone library and script can decrypt Office files without an Office installation.

At present, this only supports documents encrypted (i.e. password-protected) by Office 2010 or later. Office 2007 also uses XML, but the encryption settings are a bit different.


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
