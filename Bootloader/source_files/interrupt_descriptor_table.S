idt_start:
.fill 256,32,0x0 #256 64 bits entries, undefined


idt_end:

idt_pointer:
  .word idt_end - idt_start
  .long idt_start
