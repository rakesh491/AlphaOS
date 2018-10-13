/*******************************************************
# Author: Rakesh Kumar Lal
# rakesh491(github)
#
#*******************************************************/

#this program might not work properly...in that case just boot from hdd

.code16
.extern paging

movw $0x9000,%ax
movw %ax,%ss
movw %ax,%sp
movw %ax,%bp

jmp boot

.section .sector0
.global _start

_start:
	.skip 8 - (. - _start), 0x00

bootinfo:
	.long 0        # LBA of PVD.
	.long 0        # LBA of boot file.
	.long 0        # Length of boot file.
	.long 0        # Checksum of boot file.
	.skip 40, 0x00 # Reserved.

boot:
	# Clear interrupts and direction.
	cli
	cld

	# Jump to bootx
	ljmp $0x0000, $bootx


bootx:
    mov %dl,disk
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

    movw $0x2401,%ax
    int $0x15 # enable A20 bit
    movw $0x3,%ax
    int $0x10 # set vga text mode 3

    cli

    lgdt gdt_pointer
    mov %cr0, %eax
    or $0x1,%eax # set the protected mode bit on special CPU reg cr0
    mov %eax, %cr0
    ljmp $0x8,$protected_mode # long jump to the code segment


.include "global_descriptor_table.S"
.include "interrupt_descriptor_table.S"

.code32
protected_mode:
    mov $DATA_SEG,%ax
    mov %ax,%ds
    mov %ax,%es
    mov %ax,%fs
    mov %ax,%gs
		xor %ax,%ax
		mov $CODE_SEG,%ax
    mov %ax,%ss

movl $0xb8000,%edx
movl $hello,%ebx

protected_mode.loop:
  movb (%ebx),%al
  orb %al,%al
  jz protected_mode.done
  movb $0x3,%ah
  movl %eax,(%edx)
  add $1,%ebx
  add $2,%edx
  jmp protected_mode.loop

protected_mode.done:

.equ boot_stack_top, 0x90000
  mov $boot_stack_top,%esp
  jmp paging

cli
hlt

hello: .ascii "HW\0"
