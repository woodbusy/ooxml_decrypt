# ooxml_decrypt

A Ruby library and script for decrypting password-protected Microsoft Office XML files (.docx, .xlsx, etc.). At present,
this only supports documents encrypted (i.e. password-protected) by Office 2010 or later. Office 2007 also uses XML, but
the encryption settings are a bit different.


## Contributing

Pull requests welcome! Once you've forked and cloned the project, you can ```bundle install``` to take care of the
dependencies; after that, you're ready to code.

You can also create issues for any bugs or feature requests, but they may take longer to get done, of course.


## TODO

- Support for Office 2007 documents
- Do verification (i.e. detect when password is incorrect)

