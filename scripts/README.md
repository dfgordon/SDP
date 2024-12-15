SDP Scripts
================

The script `deploy.py` uses [a2kit](https://github.com/dfgordon/a2kit) to deploy SDP to a disk image.  This carries out the following actions:

* Create a bootable DOS 3.3 disk image (WOZ or DO)
* Copy the file images in `binaries` to the image
* Tokenize the BASIC programs and copy to the image
* Copy the file images in `shapes` to the image

After running the script the created disk image can be booted in an emulator.
