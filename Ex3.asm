.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\user32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\user32.lib

.data
    prompt db "Nhap vao xau: ", 0
    result_msg db "Xau dao nguoc: ", 0
    buffer db 100 dup(0)
    reversed db 100 dup(0)

.code
ReverseString PROC
    ; esi: Dua vao chuoi goc
    ; edi: Dua vao chuoi dao nguoc
    push ecx
    
    ; Tim kiem do dai chuoi
    xor ecx, ecx
LengthLoop:
    cmp byte ptr [esi + ecx], 0
    je StartReverse
    inc ecx
    jmp LengthLoop

StartReverse:
    dec ecx     ; Chinh lai vi tri cuoi chuoi
    
ReverseLoop:
    mov al, [esi + ecx]
    mov [edi], al
    
    inc edi
    dec ecx
    
    cmp ecx, -1
    jne ReverseLoop
    
    mov byte ptr [edi], 0   ; Null terminator
    
    pop ecx
    ret
ReverseString ENDP

start:
    ; Hien thi prompt
    invoke StdOut, addr prompt
    
    ; Nhap chuoi
    invoke StdIn, addr buffer, 100
    
    ; Dao chuoi
    mov esi, offset buffer
    mov edi, offset reversed
    call ReverseString
    
    ; Hien thi ket qua
    invoke StdOut, addr result_msg
    invoke StdOut, addr reversed
    
    ; Thoat chuong trinh
    invoke ExitProcess, 0

end start
