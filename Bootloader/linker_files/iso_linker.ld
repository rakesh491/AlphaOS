ENTRY(_start)
OUTPUT_FORMAT("binary")

/*No relocation*/

SECTIONS {
  . = 0x7c00;

	.text :{
		*(.sector0)
		*(.text)
	}

  .cd_boot1 : {
    ./object_files/cd_boot1.o(*text)
  }


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

  /*.padding : AT(0x7ffe) { SHORT(0x0000) }*/

}
