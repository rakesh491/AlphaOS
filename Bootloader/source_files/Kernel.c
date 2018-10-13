/*******************************************************
# Author: Rakesh Kumar Lal
# rakesh491(github)
#
#*******************************************************/

/*
This is a dummy kernel
meant to test the bootloader
*/

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

extern void enable_paging(void* PD_address);

uint32_t current_column_pointer = 0x0;


static void print_string(char* string, volatile unsigned char* vid_mem_offset){
  volatile unsigned char* vid_mem = (unsigned char*) vid_mem_offset;
  int j=0;
  while(string[j]!='\0'){
    *vid_mem++ = (unsigned char) string[j++];
    *vid_mem++ = 0x09;
  }
}

static void print32_hex(void* addr,volatile unsigned char* vid_mem_offset){
  uint32_t actual_addr = (uint32_t) addr;
  uint32_t and = 0xf0000000;
  uint32_t shift = 28;
  uint32_t and_shift = 4;
  uint32_t string_counter = 2;
  char string_address[] = "0x00000000";
  uint32_t addr_hex_digit;
  unsigned char character;
  unsigned int i;
  for(i=0; i<8; i++){
    addr_hex_digit = (actual_addr & and) >> shift;
    if(addr_hex_digit == 15)      character = 'f';
    else if(addr_hex_digit == 14) character = 'e';
    else if(addr_hex_digit == 13) character = 'd';
    else if(addr_hex_digit == 12) character = 'c';
    else if(addr_hex_digit == 11) character = 'b';
    else if(addr_hex_digit == 10) character = 'a';
    else if(addr_hex_digit == 9)  character = '9';
    else if(addr_hex_digit == 8)  character = '8';
    else if(addr_hex_digit == 7)  character = '7';
    else if(addr_hex_digit == 6)  character = '6';
    else if(addr_hex_digit == 5)  character = '5';
    else if(addr_hex_digit == 4)  character = '4';
    else if(addr_hex_digit == 3)  character = '3';
    else if(addr_hex_digit == 2)  character = '2';
    else if(addr_hex_digit == 1)  character = '1';
    else if(addr_hex_digit == 0)  character = '0';
    else character = 'x';

    string_address[string_counter] = character;
    string_counter++;
    and = and >> and_shift;
    shift = shift - 4 ;
  }
  print_string(string_address,vid_mem_offset);
}



void kernel_main(void){
  char* string = (char*) 0x00006000;

  char virtual[] = "VIRTUAL ADDRESS OF STRING \"string\":";

  print32_hex(string,(0xb80a0+0xa0)); //prints virtual address of string: 0x6000
                       //A quick "xp /fmt addr" on qemu monitor would show
                       //that the string is actually present at 0x9000 physical memory
  for(;;);
}
