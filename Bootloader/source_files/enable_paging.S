.text
.global enable_paging
.extern kernel_main

enable_paging:
  push %ebp
  mov %esp, %ebp

  mov 0x8(%esp), %eax
  mov %eax, %cr3

  mov %cr0, %eax
  or $0x80000001, %eax # set the PG and PM bit on special CPU reg cr0
  mov %eax, %cr0

  call kernel_main

  mov %ebp, %esp
  pop %ebp
  ret
