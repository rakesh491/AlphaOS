ENTRY(the_beginning)
OUTPUT_FORMAT("binary")

SECTIONS {
  . = 0x7c00;

  .boot1 : {
    ./object_files/boot1.o(*text)
  }

  /*.boot_sig : AT(0x7dfe) { SHORT(0xaa55) }*/


  .paging : {
    ./object_files/paging.o(*text)
    ./object_files/paging.o(*rodata)
    ./object_files/paging.o(*data)
    ./object_files/paging.o(*bss)
  }

  .enable_paging : {
    ./object_files/enable_paging.o(*text)
    ./object_files/enable_paging.o(*rodata)
    ./object_files/enable_paging.o(*data)
    ./object_files/enable_paging.o(*bss)
  }

  .Kernel : {
    ./object_files/Kernel.o(*text)
    ./object_files/Kernel.o(*rodata)
    ./object_files/Kernel.o(*data)
    ./object_files/Kernel.o(*bss)
  }

    /DISCARD/ : {
      *(.eh_frame)
    }

  /*.padding : AT(0xffff) { SHORT(0x0000) }*/

}
