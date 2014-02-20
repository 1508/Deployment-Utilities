mpack/munpack 1.7 for Windows 32-bit

I have left the program largely intact from the original DOS port. A couple of changes:

  - mpack does not need an output file specified and will default to file.msg
  - munpack adds more file recognition:
      - image/gif
      - image/jpeg
      - image/png
      - video/mpeg
      - application/postscript
      - application/pdf
      - application/x-7z-compressed
      - application/zip
  - long filename support
  - munpack now leaves the file extension intact on duplicate file names