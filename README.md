# Fauna OS

Unix-Like Micro-Kernel for the NorthStar Advantage Business Computer.

CP/M & Unix tools for debugging, loading, installing the OS into place on 
diskette.

## Items

- `CPMLOAD.COM` CP/M-80 application for copying a binary file onto diskette at
  given disk address (side, track, sector).
  This is NorthStar Advantage exculsive.

- `HELLORLD.BIN` NS-Adv Bare-Metal Hellorld/Hello World application to test C
  cross-compiler, bindings, and `CPMLOAD.COM`.
  This is NorthStar Advantage exculsive.

- `tools/extract_bootloader.sh $1 $2` Unix shell script to create a new
  diskette image, `$1`, with bootloader file, `$2`, copied into side 0,
  track 0, sector 4. This is the Unix-like alternative to `CPMLOAD.COM`.

## Copyright

Copyright (c) 2026 Sage I. Hendricks
Licensed with MIT
