; -----------------------------------------------------------------------------
; MIT License
;
; Copyright (c) 2019 Jens Kallup
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
; -----------------------------------------------------------------------------
; usage: nasm -f bin -o test test.asm
; -----------------------------------------------------------------------------
%include 'header32.asm'     ; elf32 binary header
%include "syslib32.asm"     ; system lib loader

; -----------------------------------------------------------------------------
; entry point of stub program ...
;
; Linux startup on console is stack based:
;
; EBX => numbers of arguments (see below)
; EBP => put the given argument value/name into EBP (depend by "pop ebp")
;
; $ ./stubprogram 42  A
;               |  |  |
;               |  |  +--- argv[2]
;               |  +------ argv[1]
;               +--------- argv[0]  (shall include path name + program name)
; -----------------------------------------------------------------------------
    section .text
_start:
        sys_prolog
        sys_getcmdline_args
        
        mov     esi, [ebp + 8]  ; argv[0]

        mov     ecx, 0          ; counter; string is in ESI
.repeat:
        lodsb                   ; load string byte by byte
        test    al, al          ; check if zero (terminator \0
        jz      .done           ; yes, we done the loop

        inc     ecx             ; increment counter
        jmp     .repeat         ; loop
.done:
        mov     edx, ecx        ; string length
        mov     esi, [ebp + 8]  ; the string itself
        mov     ebx, stdout     ; output goes to console
        call    sys_write

        ; -------------------------------------
        ; open argv[0], name is in EBX
        ; with read-only flag.
        ; return value in EAX will have file
        ; descriptor on success ...
        ; -------------------------------------
        mov      edx, [ebp + 8]
        sys_open edx, O_RDONLY, O_RDONLY, file_desc

        jmp     .error          ; there was an error, errno saved in EAX
.file_ok:
        mov     [file_desc], eax  ; save file descriptor from EAX

        ; ----------------------------------------------------
        ; for write the attachment:
        ; create file with (-rwxr-xr-x) access rights ...
        ;
        ; access modes of new file:
        ;   1 = --x,            |   r := read
        ;   5 = --r-x,          |   w := write
        ;   6 = --r,            |   x := exec
        ;   7 = --r-x,          |
        ;  15 = -xr-x           |   all access flag in octal !
        ; 127 = ---xr-xr-x,     |
        ; 128 = --w-------      |
        ; 255 = --wxr-xr-x,     |
        ; 256 = -r--------      |
        ; 511 = -rwxr-xr-x,     |
        ; 512 = ---------T      |
        ; 666 = --w---x--T,     |
        ; 755 = --wxr----t      |
        ; ----------------------------------------------------
%ifdef DEBUG_TEST
        sys_creat tmp_file, 0o750                           ; access right
        sys_open  tmp_file, O_WRONLY, O_WRONLY, tmp_desc

        test    eax, eax
        jns     .file_ok2

        jmp     .error
.file_ok2:
        mov     [tmp_desc], eax ; save file descriptor
%endif
        ; ---------------------------------
        ; seek to stub file size position,
        ; and read the attachment ...
        ; ---------------------------------
        sys_lseek file_desc, filesize, SEEK_SET

; -----------------------------------------------------------------------------
; for test the kernel, may removed at later time ...
; -----------------------------------------------------------------------------
        jmp     .jumper           ; over jump nex code (peephole)
%ifdef DEBUG_TEST
.read2:
        mov     ebx, [file_desc]   ; sys_open returned fd in EAX (input fd)
        mov     ecx, char_buff     ; buffer
        mov     edx, 1             ; count read (1 byte)
        call    sys_read           ; "read" kernel call
        cmp     eax, 0             ; check if pointer EOF, or null-byte
        jle     .is_eof            ; yes, close file
        ;
        mov     ebx, [tmp_desc]    ; ramfs file descriptor
        mov     ecx, char_buff     ; buffer
        mov     edx, 1             ; buffer size
        call    sys_write
        jmp     .read2             ; else, read next char
%endif
.jumper:
        call    dll_entry
.is_eof:
        syscall SYS_SYNC, nop      ; write buffers

; -----------------------------------------------------------------------------
; Linux close file descriptors automatically at end of exec. or process
; -----------------------------------------------------------------------------
        sys_close tmp_desc
        sys_close file_desc
.error:
        sys_exit  0            ; should be exit the program without segfault err.

; -----------------------------------------------------------------------------
; data segment - moved to the end of code
; -----------------------------------------------------------------------------
    section .data
;tmp_file               db "/tmp/stub.tmp", 0
;tmp_file_len           equ $ - tmp_file

cant_loadstub_msg       db "error", 10, 0
cant_loadstub_msg_len   equ $ - cant_loadstub_msg

file_desc:  dd 0
tmp_desc:   dd 0

; -----------------------------------------------------------------------------
; bss segment - null data: static allocated memory ...
; -----------------------------------------------------------------------------
    section .bss
char_buff: resb 1

; -----------------------------------------------------------------------------
; E-O-F  - End Of File (stub) ...
; -----------------------------------------------------------------------------
filesize    equ $ - $$


; -----------------------------------------------------------------------------
; now, attachment follows ...
; -----------------------------------------------------------------------------
section .text
dll_entry:
        jmp     .main

.main:  ret


section .data

; -----------------------------------------------------------------------------
; program dependcies: DLL + function name(s) ...
; -----------------------------------------------------------------------------
%define KERNEL32_DLL            ; nark, to tell nasm using kernel32.dll code
%define KERNEL32_DLL_FUNC1      ; mark, to tell nasm-lib use func1
%define KERNEL32_DLL_FUNC2      ; mark, func1 ...

; -----------------------------------------------------------------------------
; DLL import/include .data ...
; -----------------------------------------------------------------------------
%ifdef KERNEL32_DLL
%include "kernel32.asm"
%endif

