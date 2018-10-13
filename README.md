# AlphaOS

# Build Dependencies

* [gcc cross-compiler](https://wiki.osdev.org/GCC_Cross-Compiler)
* gnu xoriiso for building the CD ISO image (The ISO image might compile but not work...I am trying to fix it).


# Project Status

* The project goal is to create and implement a simple Operating system for fun.
* Right now the bootloader puts the CPU in protected mode and also enables 32-bit paging.
  The paging is not complete, bootloader sets only one page table. which would be enough for the kernel right now
* We also have a dummy kernel. which does nothing more than demonstrating the paging.
* Also I am trying to fix the ISO image which was working earlier.
