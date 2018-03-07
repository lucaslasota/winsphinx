# WinSphinx (64 bit only)

This project assembles all the files necessary for a windows
installation of the websphinx native messaging backend as well as the
websphinx for chrome/opera extension. After running make the result is
a file: `pkg.zip` which on windows can be fed into WiX which builds an
MSI installer, if you want to spare yourself the hassle, you can
download the installer from:

https://github.com/stef/winsphinx/blob/master/sphinx.msi

Note that the chrome/opera websphinx extension needs to be installed
in your browser according to the instructions in
https://github.com/stef/websphinx-chrom/blob/master/README.md

## Dependencies

This project runs on linux, it has a couple of dependencies there: 7z, gnupg,
wget, git, mingw, python, and anything else the source dependencies need.

The resulting pkg.zip needs WiX tools on Windows, 

This repo uses a bunch of submodules, which are used in assembling the package:

 - [libsphinx](https://github.com/stef/libsphinx)
 - [goldilocks](https://github.com/stef/ed448goldilocks)
 - [pysodium](https://github.com/stef/pysodium)
 - [pwdsphinx](https://github.com/stef/pwdsphinx)
 - [websphinx-firefox](https://github.com/stef/websphinx-firefox)
 - [websphinx-chrom](https://github.com/stef/websphinx-chrom)

These should be handled by the makefile.
