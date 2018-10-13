#******************************************************
# Author: Rakesh Kumar Lal
# rakesh491(github)
#
#******************************************************

#NBVR_bootloader ;)
.global the_beginning
the_beginning:
#the beginning
.code16
xor %ax,%ax
ljmp $0x0000,$boot

.extern paging

.global boot
boot:
    mov %dl,disk
    #save the disk drive in dl
    cli
    movw $0x9000,%ax
    movw %ax,%ss
    movw %ax,%sp
    movw %ax,%bp
    sti

    movb $0x02,%ah           # load second stage to memory
    movb $12,%al             # numbers of sectors to read into memory
    movb disk,%dl            # sector read from fixed/usb disk ;0 for floppy; 0x80 for hd
    movb $0,%ch              # cylinder number
    movb $0,%dh              # head number
    movb $2,%cl              # sector number
    movw $0x7e00,%bx         # load into es:bx segment :offset of buffer
    int $0x13                # disk I/O interrupt

    jmp second_sector


.fill 510-(. - the_beginning),1,0
.fill 1,2,0xaa55
# end of first sec, no more boundaries...!!

second_sector:
    movw $0x2401,%ax
    int $0x15 # enable A20 bit

    movw $0x03,%ax
    int $0x10 # set vga (0x13-video / 0x03-text) mode 3 before moving to protected mode

    cli

    lgdt gdt_pointer
    lidt idt_pointer

    mov %cr0, %eax
    or $0x1,%eax # set the protected mode bit on special CPU reg cr0
    mov %eax, %cr0
    ljmp $0x8,$protected_mode # long jump to the code segment CS=CODE_SEG,IP=protected_mode

.include "global_descriptor_table.S"
.include "interrupt_descriptor_table.S"

##protected mode begings here
.code32
protected_mode:
    mov $DATA_SEG,%ax
    mov %ax,%ds
    mov %ax,%es
    mov %ax,%fs
    mov %ax,%gs
    xor %ax,%ax
    mov $STACK_SEG,%ax
    mov %ax,%ss

##protected mode test display
movl $0xb8000,%edx
movl $hello,%ebx

protected_mode.loop:
  movb (%ebx),%al
  orb %al,%al
  jz protected_mode.done
  movb $0x3,%ah
  mov %eax,(%edx)
  add $1,%ebx
  add $2,%edx
  jmp protected_mode.loop

protected_mode.done:
#end of protected mode test disply

.equ boot_stack_top, 0x90000
  mov $boot_stack_top,%esp
  #jmp to the
  jmp paging

##forever loop for the protected mode test display
loop_forever:
  jmp loop_forever

#safety measures for the case
#when the control ever happens to bypass the forever loop :P
cli
hlt

#protected mode test display text
hello: .ascii "PROTECTED MODE: OK\0"
