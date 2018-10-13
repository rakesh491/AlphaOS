#global descriptor table
gdt_start:
    .quad 0x0

gdt_code:			        #code descriptor
    .word 0xFFFF		  #segment limit 0-15 bits
    .word 0x0			    #base first 0-15 bits
    .byte 0x0			    #base 16-23 bits
    .byte 0b10011010	#access byte
    .byte 0b11001111	#high 4 bits (flags) low 4 bits (limit 4 last bits) (limit is 20 bits wide)
    .byte 0x0			    #base 24-31 bits

gdt_data:			        #data descriptor
    .word 0xFFFF		  #segment limit 0-15 bits
    .word 0x0			    #base 0-15 bits
    .byte 0x0			    #base 16-23 bits
    .byte 0b10010010	#access byte
    .byte 0b11001111	#high 4 bits (flags),low 4 bits (limit 4 last bits)--(limit is 20 bits wide)
    .byte 0x0			    #base 24-31 bits

gdt_stack:			      #data descriptor
    .word 0xFFFF		  #segment limit 0-15 bits
    .word 0x0			    #base 0-15 bits
    .byte 0x0			    #base 16-23 bits
    .byte 0b10010010	#access byte
    .byte 0b11001111	#high 4 bits (flags),low 4 bits (limit 4 last bits)--(limit is 20 bits wide)
    .byte 0x0			    #base 24-31 bits
gdt_end:


gdt_pointer:
  .word gdt_end - gdt_start
  .long gdt_start

disk: .byte 0x0
.equ CODE_SEG, gdt_code - gdt_start
.equ DATA_SEG, gdt_data - gdt_start
.equ STACK_SEG, gdt_stack - gdt_start
