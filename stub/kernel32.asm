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

section .data
; -----------------------------------------------------------------------------
; kernel32.dll init code ...
; -----------------------------------------------------------------------------
kernel32_dll:
        db "kernel32.dll", 0        ; dll name
        db 1,0,0                    ; dll version
        db 0                        ; dll already open?
        dd kernel32_functions       ; pointer to function names
kernel32_dll_length equ $ - (kernel32_dll - 8)

; -----------------------------------------------------------------------------
; function pointer in kernel32.dll ...
; -----------------------------------------------------------------------------
kernel32_functions:
%ifdef KERNEL32_DLL_FUNC1
        dd kernel32_func1_name  ; function name 1
        dd kernel32_dll         ; back-link
%endif
%ifdef KERNEL32_DLL_FUNC2
        dd kernel32_func2_name  ; function name 2
        dd kernel32_dll         ; back-link
%endif
        dd 0                    ; end of list
; -----------------------------------------------------------------------------
; kernel32 function names ...
; -----------------------------------------------------------------------------
%ifdef KERNEL32_DLL_FUNC1
kernel32_func1_name:
        db "test1", 0
%endif
%ifdef KERNEL32_DLL_FUNC2
kernel32_func2_name:
        db "test2", 0
%endif
